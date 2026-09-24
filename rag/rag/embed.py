"""Embeddings (RAG_PLAN §2.6): the SAME model on Spark and on the device,
or the vector spaces don't line up. Default: intfloat/multilingual-e5-small
(384-d). The heavy imports are lazy so build_pack / tests don't need torch.

int8 quantization scheme — this is a contract with the Dart side and
with sqlite-vec, so it's spelled out and pinned by a test:

    v is L2-normalised (every component in [-1, 1])
    q = round(v * 127), clamped to [-127, 127], stored as signed int8
    cosine on q ≈ cosine on v (error well under 1e-2 at 384-d)

e5 requires task prefixes: "query: " for the transcript window at
runtime, "passage: " for stored texts (hint situations, scene prompts,
motifs). Mixing them up costs ~10 points of retrieval quality.
"""

from __future__ import annotations

from collections.abc import Sequence

DEFAULT_MODEL = "intfloat/multilingual-e5-small"
DIM = 384


def quantize_int8(vec: Sequence[float]) -> bytes:
    """Contract shared with Dart: round(x*127), clamp, little-endian int8."""
    out = bytearray(len(vec))
    for i, x in enumerate(vec):
        q = int(round(x * 127.0))
        q = 127 if q > 127 else -127 if q < -127 else q
        out[i] = q & 0xFF
    return bytes(out)


def dequantize_int8(buf: bytes) -> list[float]:
    return [(b - 256 if b > 127 else b) / 127.0 for b in buf]


def cosine(a: Sequence[float], b: Sequence[float]) -> float:
    dot = sum(x * y for x, y in zip(a, b))
    na = sum(x * x for x in a) ** 0.5
    nb = sum(y * y for y in b) ** 0.5
    return dot / (na * nb) if na and nb else 0.0


class Embedder:
    """sentence-transformers wrapper. Requires the `embed` extra."""

    def __init__(self, model_name: str = DEFAULT_MODEL, device: str | None = None):
        from sentence_transformers import SentenceTransformer  # lazy: torch is heavy

        self.model_name = model_name
        self.model = SentenceTransformer(model_name, device=device)
        self.version = getattr(self.model, "model_card_data", None) and str(getattr(self.model.model_card_data, "base_model_revision", "") or "") or ""

    def _encode(self, texts: list[str]) -> list[list[float]]:
        return self.model.encode(texts, normalize_embeddings=True, batch_size=64, show_progress_bar=False).tolist()

    def passages(self, texts: list[str]) -> list[list[float]]:
        return self._encode([f"passage: {t}" for t in texts])

    def queries(self, texts: list[str]) -> list[list[float]]:
        return self._encode([f"query: {t}" for t in texts])

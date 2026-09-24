"""RAG_PLAN §8.1 — the gate before anything else: the embedding model on
Spark (sentence-transformers, fp32) and the one shipped to devices
(ONNX, int8) must agree, cos > 0.99 on 100 samples, or the vector
spaces don't line up and retrieval is silently garbage.

    python -m rag.parity_check --onnx path/to/model_int8.onnx [--tokenizer intfloat/multilingual-e5-small]

Not yet run anywhere: needs the `embed` extra installed and an exported
ONNX model (e.g. via `optimum-cli export onnx` + dynamic int8
quantization). Exporting is the next step, on Spark.
"""

from __future__ import annotations

import argparse
import sys

from .embed import DEFAULT_MODEL, Embedder, cosine, dequantize_int8, quantize_int8

# 100 samples: mixed Tier-1 languages, transcript-like fragments, and
# short stored-text-like passages, so both the "query:" and "passage:"
# paths get exercised.
SAMPLES = [
    "a pak liška vyběhla z lesa a rozhlédla se",
    "kovářův syn nevěděl, kudy dál",
    "und dann kam der Wolf aus dem Wald",
    "the king asked for the golden bird",
    "i wtedy z krzaków wyszedł zając",
    "chlapec našel klíč na dně studny",
    "a princess who would rather fix clocks than dance",
    "the river has frozen solid and something is trapped beneath",
    "…co myslíš, že liška udělala?",
    "a jak to bylo dál, mami?",
] * 10


def st_embed(e: Embedder, texts: list[str], prefix: str) -> list[list[float]]:
    return e.passages(texts) if prefix == "passage" else e.queries(texts)


def onnx_embed(session, tokenizer, texts: list[str], prefix: str) -> list[list[float]]:
    import numpy as np

    enc = tokenizer([f"{prefix}: {t}" for t in texts], padding=True, truncation=True, max_length=512, return_tensors="np")
    inputs = {k: v for k, v in enc.items() if k in {i.name for i in session.get_inputs()}}
    (last_hidden,) = session.run(None, inputs)[:1]
    mask = enc["attention_mask"][..., None].astype(last_hidden.dtype)
    pooled = (last_hidden * mask).sum(1) / mask.sum(1)  # mean pooling, as e5 does
    pooled = pooled / np.linalg.norm(pooled, axis=1, keepdims=True)
    return pooled.tolist()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--onnx", required=True, help="exported (int8) ONNX model")
    ap.add_argument("--tokenizer", default=DEFAULT_MODEL)
    ap.add_argument("--model", default=DEFAULT_MODEL)
    ap.add_argument("--threshold", type=float, default=0.99)
    args = ap.parse_args()

    import onnxruntime as ort
    from transformers import AutoTokenizer

    ref = Embedder(args.model)
    session = ort.InferenceSession(args.onnx, providers=["CPUExecutionProvider"])
    tok = AutoTokenizer.from_pretrained(args.tokenizer)

    worst = 1.0
    worst_q = 1.0
    for prefix in ("query", "passage"):
        a = st_embed(ref, SAMPLES, prefix)
        b = onnx_embed(session, tok, SAMPLES, prefix)
        for va, vb in zip(a, b):
            worst = min(worst, cosine(va, vb))
            # and the int8 round-trip the device will actually store/compare
            worst_q = min(worst_q, cosine(va, dequantize_int8(quantize_int8(vb))))

    print(f"fp32 sentence-transformers vs ONNX: min cos = {worst:.4f}")
    print(f"… vs ONNX after int8 quantization:   min cos = {worst_q:.4f}")
    ok = worst_q >= args.threshold
    print("PASS" if ok else f"FAIL (threshold {args.threshold})")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

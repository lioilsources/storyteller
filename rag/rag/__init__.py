"""Offline LLM + RAG pipeline for storyteller — STORYTELLER_RAG_PLAN.md.

Everything in here runs on Spark, at night, in batch. Nothing in here
runs inside the app: the app only does retrieval over the SQLite packs
this pipeline builds (RAG_PLAN §0.1).

Stages (RAG_PLAN §2), one module each, all reading/writing JSONL under
rag/data/ so any stage can be re-run or resumed independently:

    corpus/data/raw (Go fetcher)  →  extract  →  verbalize
                                              →  hints
                                              →  transitions
                                              →  scene_prompts
                                              →  embed  →  build_pack
"""

# Vzor pro tools/cs-review — zkopírovat do $CS_REVIEW_DIR/env.sh a upravit (env.sh do repa nepatří).
export ST_RAG=/path/to/storyteller/rag            # checkout s rag/data a rag/.venv
export CS_REVIEW_DIR=~/ops-director/free10         # tales.free10.cs.jsonl + výstupy
export LITELLM_BASE_URL=http://<spark>:8080/v1     # LiteLLM s aliasy swarm-director a lab (gpt-oss)
export DIRECTOR_HINTS=~/ops-director/hints.spark.cs.jsonl  # nápovědy, které psal director — ty se neopravují
export GPTOSS_UP=~/ops-director/gptoss-up.sh       # nahodí gpt-oss-120b jako vLLM s aliasem lab

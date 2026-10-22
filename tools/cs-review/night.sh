#!/bin/zsh
# Noční korektura češtiny na SPARKu: director hlasuje o opravách, pak gpt-oss opravuje dál.
# Spouští se večer na Macu, čeká na START. Nastavení v $CS_REVIEW_DIR/env.sh (viz README).
#   nohup caffeinate -i ./night.sh >> night.log 2>&1 &
cd "${0:A:h}"; [[ -f ${CS_REVIEW_DIR:-.}/env.sh ]] && source ${CS_REVIEW_DIR:-.}/env.sh
: ${START:=0100}          # po konci okna PromoClown heartbeatu (běží na qwen36 do 00:55)
: ${VOTE_UNTIL:=02:30}    # director hlasuje nejvýš do
: ${FIX_UNTIL:=06:30}     # gpt-oss opravuje do; v 07:00 bere SPARK rozvrh (comfy)
PY=$ST_RAG/.venv/bin/python; F=$CS_REVIEW_DIR
RS='~/deploy/WorldLibraryProject/deploy/spark/rag-schedule.sh'
say() { print "$(date '+%F %T') $*"; }
hm() { date +%H%M; }
while [[ $(hm) -ge 1200 || $(hm) -lt $START ]]; do sleep 60; done
say ">>> qwen36 + flux dolů, director nahoru (bez nočních dávek)"
ssh spark "DIRECTOR_JOBS=none $RS director 2>&1 | tail -2"
for ph in cards hints; do
  LITELLM_MODEL=swarm-director $PY cs_vote.py $ph --until $VOTE_UNTIL --concurrency 8 >> $F/vote.log 2>&1
  say "hlasování $ph: $(tail -1 $F/vote.log)"
done
say ">>> director dolů, gpt-oss nahoru"
ssh spark 'cd ~/deploy/AiStack && make down-swarm-director >/dev/null 2>&1; true'
if GPTOSS_EXTRA="--max-num-seqs 12" $GPTOSS_UP; then
  export FIX_MODEL=lab
  $PY cs_fix.py cards --until $FIX_UNTIL --concurrency 12 >> $F/cards.log 2>&1   # dorovná selhané
  $PY cs_fix.py hints --until $FIX_UNTIL --concurrency 12 >> $F/hints.log 2>&1
  say "hints: $(tail -1 $F/hints.log)"
else say "!! gpt-oss nenaběhl"; fi
ssh spark "docker rm -f bench-gptoss >/dev/null 2>&1; $RS llm 2>&1 | tail -1"
say "noc hotova"

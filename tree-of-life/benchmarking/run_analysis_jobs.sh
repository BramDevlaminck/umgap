#!/bin/bash

set -eu

usage() {
  echo "Usage: $0 start stop" >&2
  exit 1
}

(($# != 2)) && usage

INPUTS_LIST_FILE=$HOME/unipept-metagenomics-scripts/tree-of-life/benchmarking/data/complete_assemblies.tsv

depend=

for i in $(seq $1 $2)
do

  # Do some parsing based on the arrayid
  ASM_ID=$(sed -n "${i}p" $INPUTS_LIST_FILE | awk -F'\t' '{print $2}')

  echo "Submitting job for analysis of $ASM_ID"
  job=$(
    qsub ./analyse_genome.job.sh \
      -v asm_id=$ASM_ID \
      -N $ASM_ID \
      -o "$VSC_DATA_VO_USER/$ASM_ID/out.log" \
      -e "$VSC_DATA_VO_USER/$ASM_ID/err.log" \
      $depend
  )

  depend="-W depend=afterany:$job"
  echo $job
done
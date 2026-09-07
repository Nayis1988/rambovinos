#!/bin/bash

OUT="/qnap/rambovinos/trimgalore"
mkdir -p "$OUT"

# T1
trim_galore --paired --quality 20 --cores 4 \
  ECI1.R1.fastq.gz ECI1.R2.fastq.gz \
  -o "$OUT"

for n in 2 3 4 5
do
  trim_galore --paired --quality 20 --cores 4 \
    ECI${n}.R1.fastq ECI${n}.R2.fastq \
    -o "$OUT"
done

# T2
for n in 1 2 3 4 5
do
  trim_galore --paired --quality 20 --cores 4 \
    ECM${n}_R1.fastq ECM${n}_R2.fastq \
    -o "$OUT"
done

# T3
trim_galore --paired --quality 20 --cores 4 \
  ECF1_R1.fastq.gz ECF1_R2.fastq.gz \
  -o "$OUT"

for n in 2 3 4 5
do
  trim_galore --paired --quality 20 --cores 4 \
    ECF${n}_R1.fastq ECF${n}_R2.fastq \
    -o "$OUT"
done

#!/bin/bash

mkdir -p /qnap/rambovinos/fastqc_raw

fastqc \
/qnap/rambovinos/raw_data/*.fastq \
/qnap/rambovinos/raw_data/*.fastq.gz \
-o /qnap/rambovinos/fastqc_raw \
-t 8

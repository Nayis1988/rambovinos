#!/bin/bash

# 06_kraken2_EC.sh
# Kraken2 para muestras ECF, ECI y ECM
# Entrada: archivos procesados por KneadData

KRAKEN="/miniconda3/envs/metagenomics/bin/kraken2"

INPUT="/qnap/rambovinos/kneaddata"
OUTPUT="/qnap/rambovinos/kraken2"
LISTA="/qnap/rambovinos/lista_EC.txt"

# Base GTDB usada anteriormente
DB="/dev/shm/k2_gtdb_genome_reps_20250609"

THREADS=20

mkdir -p "$OUTPUT"

while read -r line
do

    echo "=========================================="
    echo "Procesando Kraken2: $line"
    echo "=========================================="

    # Buscar automáticamente los archivos paired de KneadData
    R1=$(find "$INPUT/$line" -maxdepth 1 -type f \
        \( -name "*kneaddata_paired_1.fastq" -o -name "*kneaddata_paired_1.fastq.gz" \) \
        | head -1)

    R2=$(find "$INPUT/$line" -maxdepth 1 -type f \
        \( -name "*kneaddata_paired_2.fastq" -o -name "*kneaddata_paired_2.fastq.gz" \) \
        | head -1)

    echo "R1: $R1"
    echo "R2: $R2"

    # Verificar archivos
    if [[ -z "$R1" || -z "$R2" ]]
    then
        echo "ERROR: faltan archivos KneadData para $line"
        continue
    fi

    # Crear carpeta individual
    mkdir -p "$OUTPUT/$line"

    "$KRAKEN" \
        --db "$DB" \
        --memory-mapping \
        --threads "$THREADS" \
        --paired \
        "$R1" "$R2" \
        --report "$OUTPUT/$line/${line}_GTDB.report" \
        --output "$OUTPUT/$line/${line}_GTDB.output"

    if [ $? -eq 0 ]
    then
        echo "OK: Kraken2 terminó $line"
    else
        echo "ERROR: Kraken2 falló en $line"
        exit 1
    fi

done < "$LISTA"

echo "=========================================="
echo "Kraken2 terminó todas las muestras EC"
echo "=========================================="

#!/bin/bash

# 05_kneaddata_20_25.sh
# KneadData para SRR32209720-SRR32209725

INPUT="/data2/nadia/results/trimgalore_14_16_25"
OUTPUT="/data2/nadia/results/kneaddata_20_25"
LISTA="/data2/nadia/lista_20_25.txt"

KNEADDATA="/data2/nadia/kneaddata_env/bin/kneaddata"

# Prefijo de la base Bowtie2 de Bos taurus
DB="/data2/nadia/docs/bos_taurus_ref/bos_taurus"

THREADS=20

mkdir -p "$OUTPUT"

while read -r line
do

    R1="$INPUT/${line}_1_val_1.fq.gz"
    R2="$INPUT/${line}_2_val_2.fq.gz"

    echo "=========================================="
    echo "Procesando: $line"
    echo "R1: $R1"
    echo "R2: $R2"
    echo "=========================================="

    # Verificar que existan ambos archivos
    if [[ ! -f "$R1" || ! -f "$R2" ]]
    then
        echo "ERROR: faltan archivos para $line"
        continue
    fi

    # Crear directorio individual
    mkdir -p "$OUTPUT/$line"

    # Ejecutar KneadData
    "$KNEADDATA" \
        --input1 "$R1" \
        --input2 "$R2" \
        --reference-db "$DB" \
        --output "$OUTPUT/$line" \
        --threads "$THREADS" \
        --remove-intermediate-output

    if [ $? -eq 0 ]
    then
        echo "OK: $line terminó correctamente"
    else
        echo "ERROR: KneadData falló en $line"
        exit 1
    fi

done < "$LISTA"

echo "=========================================="
echo "KneadData terminó SRR32209720-25"
echo "=========================================="

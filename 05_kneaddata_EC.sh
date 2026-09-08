#!/bin/bash

# 05_kneaddata_EC.sh
# KneadData para muestras ECF, ECI y ECM

source /miniconda3/etc/profile.d/conda.sh
conda activate /data2/nadia/kneaddata_env

INPUT="/qnap/rambovinos/trimgalore"
OUTPUT="/qnap/rambovinos/kneaddata"
LISTA="/qnap/rambovinos/lista_EC.txt"

#KNEADDATA="/data2/nadia/kneaddata_env/bin/kneaddata"

# Prefijo de la base Bowtie2 de Bos taurus
DB="/data2/nadia/docs/bos_taurus_ref/bos_taurus"

THREADS=20

mkdir -p "$OUTPUT"

while read -r line
do

    # ECI usa punto antes de R1/R2
    if [[ "$line" == ECI* ]]
    then
        R1="$INPUT/${line}.R1_val_1.fq.gz"
        R2="$INPUT/${line}.R2_val_2.fq.gz"
    else
        # ECF y ECM usan guion bajo
        R1="$INPUT/${line}_R1_val_1.fq.gz"
        R2="$INPUT/${line}_R2_val_2.fq.gz"
    fi

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

    # Crear directorio individual para cada muestra
    mkdir -p "$OUTPUT/$line"

    # Ejecutar KneadData
    kneaddata \
        --input1 "$R1" \
        --input2 "$R2" \
        --reference-db "$DB" \
        --output "$OUTPUT/$line" \
        --threads "$THREADS" \
	--bypass-trim \
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
echo "KneadData terminó todas las muestras EC"
echo "=========================================="

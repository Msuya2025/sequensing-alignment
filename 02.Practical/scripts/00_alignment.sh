#!/bin/bash

# =====================================================================
# SCRIPT 0: READ ALIGNMENT
# =====================================================================
# This script takes raw FASTQ reads and aligns them to a reference genome.
# It outputs a sorted, indexed BAM file for each sample.
#
# ⚠️ ENVIRONMENT: Run this in your environment that has 'bwa' and 'samtools'.
# =====================================================================

# --- SET YOUR PATHS HERE ---
# Path to the reference genome
REF="../alignment_excercise/reference/reference.fasta"

# Folder where your raw FASTQ files are located
FASTQ_DIR="clean_reads/"

# Folder where you want the output BAM files to be saved
OUT_DIR="results/alignment/"

# ---------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------------

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

echo "=================================================="
echo "Starting Alignment Pipeline..."
echo "Reference: $REF"
echo "Looking for FASTQ files in: $FASTQ_DIR"
echo "=================================================="

# 1. Index the reference genome
if [ ! -f "${REF}.bwt" ]; then
    echo "Indexing reference genome..."
    bwa index "$REF"
fi

# 2. Loop through all R1 files
for R1 in "$FASTQ_DIR"*_R1_trimmed.fastq.gz
do
    # Check if R1 files exist
    if [ ! -f "$R1" ]; then
        echo "ERROR: No _R1_trimmed.fastq.gz files found in $FASTQ_DIR"
        exit 1
    fi

    # Define the R2 file based on the R1 file name
    R2="${R1/_R1_trimmed.fastq.gz/_R2_trimmed.fastq.gz}"
    
    # Extract sample name (e.g., "ARH2440")
    SAMPLE=$(basename "$R1" _R1_trimmed.fastq.gz)
    
    echo "--------------------------------------------------"
    echo "Processing sample: $SAMPLE"
    echo "  Read 1: $R1"
    echo "  Read 2: $R2"
    
    # 3. Run BWA-MEM to align reads
    echo "  -> Aligning reads..."
    bwa mem "$REF" "$R1" "$R2" | \
        samtools view -b - | \
        samtools sort -o "${OUT_DIR}${SAMPLE}.sorted.bam" -
    
    # 4. Index the final BAM file
    echo "  -> Indexing BAM file..."
    samtools index "${OUT_DIR}${SAMPLE}.sorted.bam"
    
    echo "  -> Success! Saved ${OUT_DIR}${SAMPLE}.sorted.bam"
done

echo "=================================================="
echo "Alignment complete! Check the $OUT_DIR folder."
echo "Next step: Run 01_variant_calling.sh"

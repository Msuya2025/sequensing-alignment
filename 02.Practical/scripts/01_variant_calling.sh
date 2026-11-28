#!/bin/bash

# =====================================================================
# SCRIPT 1: VARIANT CALLING
# =====================================================================
# ⚠️ ENVIRONMENT: Run this in your 'bsftool' environment.
# =====================================================================

# --- SET YOUR PATHS HERE ---
REF="reference/reference.fasta"
BAM_DIR="results/alignment/"
OUT_DIR="results/vcf_files/"

# ---------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------------

mkdir -p "$OUT_DIR"

echo "Starting Variant Calling..."
echo "Reference: $REF"
echo "Looking for BAM files in: $BAM_DIR"
echo "------------------------------------------------"

# Loop through all sorted BAM files
for BAM_FILE in "$BAM_DIR"*.sorted.bam
do
    if [ ! -f "$BAM_FILE" ]; then
        echo "ERROR: No .sorted.bam files found in $BAM_DIR"
        exit 1
    fi

    SAMPLE=$(basename "$BAM_FILE" .sorted.bam)
    
    echo "Processing sample: $SAMPLE ..."
    
    bcftools mpileup -a AD,DP -f "$REF" "$BAM_FILE" | bcftools call -mv -Oz -o "${OUT_DIR}${SAMPLE}_variants.vcf.gz"
    
    tabix -p vcf "${OUT_DIR}${SAMPLE}_variants.vcf.gz"
    
    echo "  -> Success! Saved to ${OUT_DIR}${SAMPLE}_variants.vcf.gz"
done

echo "------------------------------------------------"
echo "Variant calling complete! Check the $OUT_DIR folder."

#!/bin/bash

# =====================================================================
# SCRIPT 2: CONSENSUS GENERATION
# =====================================================================
# This script takes the VCF files and applies the mutations to the 
# reference genome to create a complete "consensus" FASTA file for each sample.
#
# ⚠️ ENVIRONMENT: Run this in your 'bsftool' environment.
# =====================================================================

# --- SET YOUR PATHS HERE ---
# Path to the reference genome
REF="../alignment_excercise/reference/reference.fasta"

# Folder containing the VCF files from Script 1
VCF_DIR="results/vcf_files/"

# Folder where the consensus FASTA files will be saved
OUT_DIR="results/consensus/"

# ---------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------------

mkdir -p "$OUT_DIR"

echo "Generating consensus sequences..."
echo "Looking for VCFs in: $VCF_DIR"
echo "------------------------------------------------"

# Loop through all compressed VCF files
for VCF_FILE in "$VCF_DIR"*.vcf.gz
do
    # Check if VCF files exist
    if [ ! -f "$VCF_FILE" ]; then
        echo "ERROR: No .vcf.gz files found in $VCF_DIR"
        echo "Did you run Script 1 first?"
        exit 1
    fi

    # Extract sample name
    SAMPLE=$(basename "$VCF_FILE" _variants.vcf.gz)
    
    echo "Creating consensus for: $SAMPLE ..."
    
    # Generate consensus FASTA
    bcftools consensus -f "$REF" -o "${OUT_DIR}${SAMPLE}_consensus.fasta" "$VCF_FILE"
    
    echo "  -> Created ${OUT_DIR}${SAMPLE}_consensus.fasta"
done

echo "------------------------------------------------"
echo "Consensus generation complete! Check the $OUT_DIR folder."

#!/bin/bash

# =====================================================================
# SCRIPT 3: MULTIPLE SEQUENCE ALIGNMENT (MSA)
# =====================================================================
# This script combines all consensus FASTA files and runs MAFFT to align them.
#
# ⚠️ ENVIRONMENT: Run this in your 'mafft_env' environment.
# =====================================================================

# --- SET YOUR PATHS HERE ---
# Folder containing the consensus FASTA files from Script 2
# (You can also add other strains, like Omicron, to this folder to compare!)
INPUT_DIR="results/consensus/"

# Folder where the final alignment will be saved
OUT_DIR="results/msa/"

# ---------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------------

mkdir -p "$OUT_DIR"

echo "Combining all FASTA files in $INPUT_DIR..."
cat "$INPUT_DIR"*.fasta > "${OUT_DIR}all_sequences.fasta"

# Check if MAFFT is installed
if ! command -v mafft &> /dev/null
then
    echo "ERROR: MAFFT is not installed or not in your PATH."
    echo "Please activate your mafft environment."
    exit 1
fi

echo "Running MAFFT Multiple Sequence Alignment..."
mafft "${OUT_DIR}all_sequences.fasta" > "${OUT_DIR}alignment.fasta"

echo "------------------------------------------------"
echo "MSA complete! Open ${OUT_DIR}alignment.fasta in Jalview or MEGA."


mkdir -p ./alignment

for R1 in ./clean_reads/*_R1_trimmed.fastq.gz
do

    SAMPLE=$(basename "$R1" _R1_trimmed.fastq.gz)

    R2="./clean_reads/${SAMPLE}_R2_trimmed.fastq.gz"

    echo "Aligning sample: $SAMPLE"

    bwa mem ./reference/reference.fasta "$R1" "$R2" \
    > ./alignment/${SAMPLE}.sam

done

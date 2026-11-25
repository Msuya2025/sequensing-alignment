for SAM in ./alignment/*.sam
do

    SAMPLE=$(basename "$SAM" .sam)

    echo "Processing: $SAMPLE"

    samtools view -b "$SAM" | \
    samtools sort -o "./alignment/${SAMPLE}.sorted.bam"

    samtools index "./alignment/${SAMPLE}.sorted.bam"

done

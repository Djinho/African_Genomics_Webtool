#!/bin/bash

# Step 1: Extract African population samples from the metadata file
echo "Extracting African population samples..."
grep -E "YRI|LWK|GWD|MSL|ESN" phase1_integrated_calls.20101123.ALL.panel | cut -f1 > african_samples.txt
echo "African sample IDs saved to african_samples.txt."

# Step 2: Subset VCF files for African populations
echo "Subsetting VCF files for African populations..."

# Loop through all chromosome VCF files
for vcf_file in ALL.chr*.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz; do
    # Get the base name of the file (without extension)
    base_name=$(basename "$vcf_file" .vcf.gz)

    # Subset the VCF file for African populations
    echo "Processing $vcf_file..."
    bcftools view -S african_samples.txt "$vcf_file" -o "${base_name}_african.vcf.gz"

    # Index the subsetted VCF file
    bcftools index "${base_name}_african.vcf.gz"

    echo "Subsetted VCF saved to ${base_name}_african.vcf.gz."
done

echo "All VCF files subsetted for African populations."

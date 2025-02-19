#!/bin/bash

# This script calculates allele frequencies from multiple VCF files using bcftools.
# It loops through all VCF files matching the pattern ALL.chr*_maf_filtered.vcf.gz
# and extracts allele frequency information.

# Loop through all VCF files matching the pattern
for vcf_file in ALL.chr*_maf_filtered.vcf.gz; do
    # Extract the base name without the .vcf.gz extension for structured output naming
    base_name=$(basename "$vcf_file" .vcf.gz)

    # Display a message indicating which file is being processed
    echo "Calculating allele frequencies for $vcf_file..."

    # Use bcftools to extract allele frequency information from the VCF file
    # -f '%CHROM\t%POS\t%REF\t%ALT\t%AF\n' specifies the format:
    #   %CHROM - Chromosome number
    #   %POS   - Position in the genome
    #   %REF   - Reference allele
    #   %ALT   - Alternative allele
    #   %AF    - Allele frequency
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AF\n' "$vcf_file" > "${base_name}_allele_frequencies.txt"

    # Print a message confirming that results have been saved
    echo "Allele frequencies saved to ${base_name}_allele_frequencies.txt."
done

#!/bin/bash

# This script calculates FST (Fixation Index) for multiple VCF files using VCFtools.
# It loops through all VCF files matching the pattern ALL.chr*_maf_filtered.vcf.gz
# and computes FST between two populations (YRI and LWK).

# Loop through all VCF files matching the pattern
for vcf_file in ALL.chr*_maf_filtered.vcf.gz; do
    # Extract the base name (removing .vcf.gz extension) for output file naming
    base_name=$(basename "$vcf_file" .vcf.gz)
    
    # Print a message indicating which file is being processed
    echo "Calculating FST for $vcf_file..."

    # Run VCFtools to calculate FST between the two populations
    vcftools --gzvcf "$vcf_file" \   # Specifies the input gzipped VCF file
             --weir-fst-pop yri_samples.txt \  # Specifies the first population file (YRI)
             --weir-fst-pop lwk_samples.txt \  # Specifies the second population file (LWK)
             --out "${base_name}_fst"  # Specifies the output prefix for the results

    # Print a message indicating where the results have been saved
    echo "FST results saved to ${base_name}_fst.weir.fst."
done

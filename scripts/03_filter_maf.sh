#!/bin/bash
# =============================================================================
# STEP 3: Filter by Minor Allele Frequency (MAF)
# =============================================================================
# Why: Very rare variants (seen in <5% of people) are:
#      - Statistically unreliable
#      - Often sequencing errors
#      - Not useful for population comparisons
#
# What this does:
#   Keeps only variants where the minor allele appears in ≥5% of samples
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 3: Filtering by MAF >= 0.05"
echo "========================================"

echo "Variants before filtering:"
before=$(bcftools view -H chr22_african.vcf.gz | wc -l)
echo "  $before variants"

echo ""
echo "Filtering (keeping MAF >= 0.05)..."
# --min-af 0.05 = keep variants where minor allele freq >= 5%
# This removes very rare variants
bcftools view -q 0.05:minor chr22_african.vcf.gz -Oz -o chr22_african_maf05.vcf.gz

echo "Indexing filtered VCF..."
bcftools index -t chr22_african_maf05.vcf.gz

echo ""
echo "========================================"
echo "Complete! Results:"
echo "========================================"
after=$(bcftools view -H chr22_african_maf05.vcf.gz | wc -l)
echo "Variants after filtering: $after"
echo "Removed: $((before - after)) rare variants"
echo ""
ls -lh chr22_african_maf05.vcf.gz*
echo ""
echo "SUCCESS! Run 04_calculate_af.sh next."

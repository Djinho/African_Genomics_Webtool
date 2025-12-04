#!/bin/bash
# =============================================================================
# STEP 2: Subset VCF to African Populations Only
# =============================================================================
# Why: The full VCF has ~2,500 samples from all continents.
#      We only want the 504 African samples (YRI, LWK, GWD, MSL, ESN).
# 
# What this does:
#   1. Extracts African sample IDs from the panel file
#   2. Creates a new VCF containing only those samples
#   3. Indexes the new VCF for fast access
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 2: Subsetting to African Samples"
echo "========================================"

# Extract African sample IDs from panel file
# grep -E "YRI|LWK|..." finds rows containing these population codes
# cut -f1 extracts just the first column (sample ID)
echo "[1/4] Extracting African sample IDs..."
grep -E "YRI|LWK|GWD|MSL|ESN" sample_panel.txt | cut -f1 > african_samples.txt
echo "  Found $(wc -l < african_samples.txt) African samples"

# Also create per-population sample files (needed for FST later)
echo "[2/4] Creating per-population sample lists..."
for pop in YRI LWK GWD MSL ESN; do
    grep -w "$pop" sample_panel.txt | cut -f1 > ${pop}_samples.txt
    echo "  $pop: $(wc -l < ${pop}_samples.txt) samples"
done

# Subset the VCF to only African samples
# bcftools view -S file.txt = keep only samples listed in file.txt
# -Oz = output as compressed VCF (.gz)
echo "[3/4] Subsetting VCF (this may take a minute)..."
bcftools view -S african_samples.txt \
    ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
    -Oz -o chr22_african.vcf.gz

# Index the new VCF
echo "[4/4] Indexing new VCF..."
bcftools index -t chr22_african.vcf.gz

echo ""
echo "========================================"
echo "Complete! Results:"
echo "========================================"
ls -lh chr22_african.vcf.gz*
echo ""
echo "Variant count check:"
echo "  Original: $(bcftools view -H ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz | wc -l) variants"
echo "  African subset: $(bcftools view -H chr22_african.vcf.gz | wc -l) variants"
echo ""
echo "SUCCESS! Run 03_filter_maf.sh next."

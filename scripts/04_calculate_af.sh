#!/bin/bash
# =============================================================================
# STEP 4: Calculate Allele Frequencies Per Population (FIXED)
# =============================================================================
# Why: Allele frequency tells you how common a variant is in a population.
#      Comparing AFs across populations shows genetic diversity.
#
# Fix: Must use +fill-tags to RECALCULATE AF after subsetting
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 4: Calculating Allele Frequencies"
echo "========================================"

mkdir -p results

for pop in YRI LWK GWD MSL ESN; do
    echo "Processing $pop..."
    
    # Subset to population AND recalculate AF using +fill-tags
    bcftools view -S ${pop}_samples.txt chr22_african_maf05.vcf.gz | \
    bcftools +fill-tags -- -t AF | \
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AF\n' > results/${pop}_allele_freq.txt
    
    sed -i '1i CHROM\tPOS\tREF\tALT\tAF' results/${pop}_allele_freq.txt
    echo "  Done"
done

# Create combined file
echo ""
echo "Creating combined frequency file..."
echo -e "CHROM\tPOS\tREF\tALT\tYRI_AF\tLWK_AF\tGWD_AF\tMSL_AF\tESN_AF" > results/combined_af.txt

paste <(bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' chr22_african_maf05.vcf.gz) \
      <(tail -n +2 results/YRI_allele_freq.txt | cut -f5) \
      <(tail -n +2 results/LWK_allele_freq.txt | cut -f5) \
      <(tail -n +2 results/GWD_allele_freq.txt | cut -f5) \
      <(tail -n +2 results/MSL_allele_freq.txt | cut -f5) \
      <(tail -n +2 results/ESN_allele_freq.txt | cut -f5) >> results/combined_af.txt

echo ""
echo "========================================"
echo "Complete! Verifying AFs differ:"
echo "========================================"
head -5 results/combined_af.txt | column -t
echo ""
echo "SUCCESS! Run 05_calculate_fst.sh next."

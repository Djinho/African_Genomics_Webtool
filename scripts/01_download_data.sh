#!/bin/bash
# =============================================================================
# STEP 1: Download 1000 Genomes Data (Chromosome 22 only - for testing)
# =============================================================================
# This downloads:
#   1. VCF file - contains genetic variants for ~2,500 people
#   2. TBI file - index for fast random access to the VCF
#   3. Panel file - metadata mapping sample IDs to populations
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 1: Downloading 1000 Genomes Data"
echo "========================================"

echo "[1/3] Downloading chr22 VCF file (~200MB)..."
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz

echo "[2/3] Downloading index file..."
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi

echo "[3/3] Downloading sample panel..."
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel -O sample_panel.txt

echo ""
echo "========================================"
echo "Download complete! Verifying files..."
echo "========================================"
ls -lh *.vcf.gz *.tbi sample_panel.txt

echo ""
echo "Checking African samples in panel file:"
for pop in YRI LWK GWD MSL ESN; do
    count=$(grep -w "$pop" sample_panel.txt | wc -l)
    echo "  $pop: $count samples"
done

echo ""
echo "SUCCESS! Run 02_subset_african.sh next."

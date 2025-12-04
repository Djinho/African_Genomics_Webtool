#!/bin/bash
# =============================================================================
# STEP 6: Run ADMIXTURE Analysis
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

export PATH="$HOME/plink19:$PATH"
export PATH="$HOME/dist/admixture_linux-1.3.0:$PATH"

echo "========================================"
echo "STEP 6: Running ADMIXTURE"
echo "========================================"

mkdir -p results/admixture
cd results/admixture

# Step 1: Convert VCF, keeping original IDs (dots)
echo "[1/5] Converting VCF to PLINK..."
plink --vcf ../../chr22_african_maf05.vcf.gz \
      --make-bed \
      --out temp1 \
      --allow-extra-chr \
      --double-id

# Step 2: Assign unique IDs using line numbers
echo "[2/5] Assigning unique variant IDs..."
awk '{$2="var"NR; print}' temp1.bim > temp2.bim
cp temp1.bed temp2.bed
cp temp1.fam temp2.fam

# Step 3: LD prune
echo "[3/5] LD pruning..."
plink --bed temp2.bed --bim temp2.bim --fam temp2.fam \
      --indep-pairwise 50 10 0.1 \
      --out prune \
      --allow-extra-chr

plink --bed temp2.bed --bim temp2.bim --fam temp2.fam \
      --extract prune.prune.in \
      --make-bed \
      --out african_final \
      --allow-extra-chr

echo "  Final: $(wc -l < african_final.bim) variants"

# Step 4: Run ADMIXTURE
echo "[4/5] Running ADMIXTURE..."
for K in 2 3 4 5; do
    echo "  K=$K..."
    admixture --cv african_final.bed $K > log_K${K}.txt 2>&1 || echo "  K=$K failed"
done

# Step 5: Population labels
echo "[5/5] Creating labels..."
awk 'FNR==NR {pop[$1]=$2; next} {print $1, pop[$1]}' \
    ../../sample_panel.txt african_final.fam > sample_populations.txt

rm -f temp1.* temp2.* prune.*

echo ""
echo "========================================"
echo "Results:"
echo "========================================"
ls -lh african_final.*.Q 2>/dev/null
grep "CV error" log_K*.txt 2>/dev/null

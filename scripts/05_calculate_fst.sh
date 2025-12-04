#!/bin/bash
# =============================================================================
# STEP 5: Calculate FST Between Population Pairs
# =============================================================================
# Why: FST measures how genetically different two populations are.
#      0 = identical, 1 = completely different
#      Typical FST within Africa: 0.01-0.05 (low, because humans are similar)
#
# Tool: vcftools --weir-fst-pop
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 5: Calculating FST"
echo "========================================"

mkdir -p results/fst

# All pairwise comparisons between 5 populations = 10 pairs
populations=(YRI LWK GWD MSL ESN)

for ((i=0; i<${#populations[@]}; i++)); do
    for ((j=i+1; j<${#populations[@]}; j++)); do
        pop1=${populations[$i]}
        pop2=${populations[$j]}
        
        echo "Calculating FST: $pop1 vs $pop2..."
        
        vcftools --gzvcf chr22_african_maf05.vcf.gz \
            --weir-fst-pop ${pop1}_samples.txt \
            --weir-fst-pop ${pop2}_samples.txt \
            --out results/fst/${pop1}_${pop2} 2>/dev/null
    done
done

# Summarize results
echo ""
echo "========================================"
echo "FST Summary (genome-wide averages):"
echo "========================================"
echo ""

for file in results/fst/*.log; do
    pair=$(basename "$file" .log)
    # Extract weighted FST from log file
    fst=$(grep "weighted" "$file" | awk '{print $NF}')
    echo "$pair: $fst"
done

echo ""
echo "Files created:"
ls -lh results/fst/*.weir.fst | head -5
echo ""
echo "SUCCESS! Data pipeline complete."
echo "Next: Build web app to visualize these results."

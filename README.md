# African Genomics Explorer

Interactive web application for exploring genetic diversity across five African populations from the 1000 Genomes Project.

![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)
![Flask](https://img.shields.io/badge/Flask-2.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## Overview

This project analyzes chromosome 22 variant data from five African populations:

| Population | Code | Location | Samples |
|------------|------|----------|---------|
| Yoruba | YRI | Ibadan, Nigeria | 108 |
| Luhya | LWK | Webuye, Kenya | 99 |
| Gambian | GWD | Western Division, The Gambia | 113 |
| Mende | MSL | Sierra Leone | 85 |
| Esan | ESN | Nigeria | 99 |

**Total: 504 individuals, 134,065 variants**

## Features

- **PCA Analysis**: Interactive scatter plots showing population structure (PC1 vs PC2, PC1 vs PC3)
- **FST Heatmap**: Pairwise genetic differentiation between populations
- **Allele Frequency Comparison**: Compare variant frequencies across any two populations

## Screenshots

The webapp features a modern dark theme with interactive Plotly visualizations.

## Installation

```bash
# Clone the repository
git clone https://github.com/Djinho/African_Genomics_Webtool.git
cd African_Genomics_Webtool

# Install dependencies
pip install -r webapp/requirements.txt
```

## Usage

### Running the Web Application

```bash
cd webapp
python app.py
```

Then open http://localhost:5000 in your browser.

### Reproducing the Analysis

The analysis pipeline scripts are provided in numbered order:

1. `01_download_data.sh` - Download chr22 VCF from 1000 Genomes
2. `02_subset_african.sh` - Subset to African samples only
3. `03_filter_maf.sh` - Filter variants by MAF > 5%
4. `04_calculate_af.sh` - Calculate allele frequencies per population
5. `05_calculate_fst.sh` - Calculate pairwise FST values
6. `06_run_admixture.sh` - Run PCA/ADMIXTURE analysis

**Requirements for pipeline:**
- bcftools
- vcftools
- PLINK 1.9

## Project Structure

```
African_Genomics_Webtool/
├── webapp/
│   ├── app.py                 # Flask application
│   ├── requirements.txt       # Python dependencies
│   ├── templates/
│   │   ├── base.html          # Base template with navbar
│   │   ├── home.html          # Landing page
│   │   ├── pca.html           # PCA analysis page
│   │   ├── fst.html           # FST analysis page
│   │   └── allele_frequency.html
│   └── static/
│       ├── css/style.css      # Dark theme styling
│       └── js/plots.js        # Plotly visualization functions
├── scripts/                   # Analysis pipeline scripts
└── README.md
```

## Methods

- **PCA**: Computed using PLINK 1.9 `--pca` on LD-pruned variants
- **FST**: Weir and Cockerham's estimator via VCFtools `--weir-fst-pop`
- **Allele Frequencies**: Calculated per population using VCFtools `--freq`

## Data Source

[1000 Genomes Project Phase 3](https://www.internationalgenome.org/)

## Technologies

- **Backend**: Flask, Pandas
- **Frontend**: HTML5, CSS3, JavaScript
- **Visualization**: Plotly.js
- **Bioinformatics**: PLINK, VCFtools, bcftools

## License

MIT License

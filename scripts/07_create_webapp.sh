#!/bin/bash
# =============================================================================
# STEP 7: Create Flask Web App
# =============================================================================

set -e
cd ~/African_Genomics_Webtool

echo "========================================"
echo "STEP 7: Creating Web App"
echo "========================================"

# Install dependencies
echo "Installing Python packages..."
pip install flask pandas plotly --quiet --break-system-packages 2>/dev/null || pip install flask pandas plotly --quiet

# Create webapp directory
mkdir -p webapp/templates

# Create Flask app
echo "Creating app.py..."
cat << 'EOF' > webapp/app.py
from flask import Flask, render_template
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import plotly
import json
import os

app = Flask(__name__)

@app.route('/')
def index():
    # Load PCA data
    pca = pd.read_csv('../results/admixture/african_pca_labeled.txt', 
                      sep=r'\s+', header=None,
                      names=['FID','IID','PC1','PC2','PC3','PC4','PC5',
                             'PC6','PC7','PC8','PC9','PC10','Population'])
    
    # PCA Plot
    fig_pca = px.scatter(pca, x='PC1', y='PC2', color='Population',
                         title='PCA of African Populations (Chromosome 22)',
                         hover_data=['IID'])
    fig_pca.update_layout(height=500, template='plotly_white')
    pca_json = json.dumps(fig_pca, cls=plotly.utils.PlotlyJSONEncoder)
    
    # Load FST data and create heatmap
    populations = ['YRI', 'LWK', 'GWD', 'MSL', 'ESN']
    fst_matrix = pd.DataFrame(0.0, index=populations, columns=populations)
    
    fst_dir = '../results/fst'
    for f in os.listdir(fst_dir):
        if f.endswith('.weir.fst'):
            pair = f.replace('.weir.fst', '')
            pop1, pop2 = pair.split('_')
            df = pd.read_csv(f'{fst_dir}/{f}', sep='\t')
            fst_vals = df['WEIR_AND_COCKERHAM_FST'].replace([float('inf'), float('-inf')], float('nan'))
            mean_fst = fst_vals.dropna().mean()
            if pd.notna(mean_fst):
                fst_matrix.loc[pop1, pop2] = mean_fst
                fst_matrix.loc[pop2, pop1] = mean_fst
    
    fig_fst = px.imshow(fst_matrix, text_auto='.4f',
                        title='FST Between African Populations (0=identical, 1=different)',
                        color_continuous_scale='Blues')
    fig_fst.update_layout(height=500)
    fst_json = json.dumps(fig_fst, cls=plotly.utils.PlotlyJSONEncoder)
    
    # Allele frequency comparison
    af = pd.read_csv('../results/combined_af.txt', sep='\t', nrows=5000)
    fig_af = px.scatter(af, x='YRI_AF', y='LWK_AF', opacity=0.5,
                        title='Allele Frequency: Yoruba (Nigeria) vs Luhya (Kenya)',
                        labels={'YRI_AF': 'Yoruba AF', 'LWK_AF': 'Luhya AF'})
    fig_af.add_shape(type='line', x0=0, y0=0, x1=1, y1=1,
                     line=dict(dash='dash', color='red'))
    fig_af.update_layout(height=500, template='plotly_white')
    af_json = json.dumps(fig_af, cls=plotly.utils.PlotlyJSONEncoder)
    
    return render_template('index.html', 
                          pca_plot=pca_json, 
                          fst_plot=fst_json,
                          af_plot=af_json,
                          n_samples=len(pca),
                          n_variants=len(af))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
EOF

# Create HTML template
echo "Creating template..."
cat << 'EOF' > webapp/templates/index.html
<!DOCTYPE html>
<html>
<head>
    <title>African Genomics Webtool</title>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            margin: 0; 
            padding: 20px;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            color: #eee;
        }
        .container { max-width: 1400px; margin: 0 auto; }
        h1 { 
            text-align: center; 
            color: #00d4ff;
            margin-bottom: 10px;
            font-size: 2.5em;
        }
        .subtitle {
            text-align: center;
            color: #888;
            margin-bottom: 30px;
        }
        .stats {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-bottom: 30px;
        }
        .stat {
            background: rgba(255,255,255,0.1);
            padding: 15px 30px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-value { font-size: 2em; color: #00d4ff; }
        .stat-label { color: #888; }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .card {
            background: rgba(255,255,255,0.05);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        .card-full { grid-column: 1 / -1; }
        .plot { width: 100%; height: 500px; }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
        }
        @media (max-width: 900px) {
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧬 African Genomics Webtool</h1>
        <p class="subtitle">Visualizing genetic diversity across African populations using 1000 Genomes data</p>
        
        <div class="stats">
            <div class="stat">
                <div class="stat-value">{{ n_samples }}</div>
                <div class="stat-label">Samples</div>
            </div>
            <div class="stat">
                <div class="stat-value">5</div>
                <div class="stat-label">Populations</div>
            </div>
            <div class="stat">
                <div class="stat-value">{{ n_variants }}</div>
                <div class="stat-label">Variants</div>
            </div>
        </div>

        <div class="grid">
            <div class="card">
                <div id="pca" class="plot"></div>
            </div>
            <div class="card">
                <div id="fst" class="plot"></div>
            </div>
            <div class="card card-full">
                <div id="af" class="plot"></div>
            </div>
        </div>

        <div class="footer">
            <p>Data: 1000 Genomes Project Phase 3 | Populations: YRI (Yoruba, Nigeria), LWK (Luhya, Kenya), GWD (Gambian), MSL (Mende, Sierra Leone), ESN (Esan, Nigeria)</p>
        </div>
    </div>

    <script>
        var pca = {{ pca_plot | safe }};
        var fst = {{ fst_plot | safe }};
        var af = {{ af_plot | safe }};
        
        Plotly.newPlot('pca', pca.data, pca.layout);
        Plotly.newPlot('fst', fst.data, fst.layout);
        Plotly.newPlot('af', af.data, af.layout);
    </script>
</body>
</html>
EOF

echo ""
echo "========================================"
echo "Web App Created!"
echo "========================================"
echo ""
echo "To run the app:"
echo "  cd ~/African_Genomics_Webtool/webapp"
echo "  python app.py"
echo ""
echo "Then open: http://localhost:5000"
EOF

chmod +x 07_create_webapp.sh
./07_create_webapp.sh

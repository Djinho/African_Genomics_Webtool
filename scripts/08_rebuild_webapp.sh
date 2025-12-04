#!/bin/bash
# =============================================================================
# STEP 8: Rebuild Web App (Proper Structure)
# =============================================================================

cd ~/African_Genomics_Webtool

echo "Creating webapp structure..."
mkdir -p webapp/static/css webapp/static/js webapp/templates

# === CSS ===
cat << 'EOF' > webapp/static/css/style.css
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
    min-height: 100vh;
    color: #fff;
}

.navbar {
    background: rgba(0,0,0,0.3);
    padding: 15px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.navbar h1 {
    font-size: 1.5em;
    color: #00d4ff;
}

.navbar nav a {
    color: #ccc;
    text-decoration: none;
    margin-left: 30px;
    transition: color 0.3s;
}

.navbar nav a:hover, .navbar nav a.active {
    color: #00d4ff;
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 30px;
}

.hero {
    text-align: center;
    padding: 40px 20px;
}

.hero h2 {
    font-size: 2.5em;
    margin-bottom: 15px;
    background: linear-gradient(90deg, #00d4ff, #00ff88);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.hero p {
    color: #aaa;
    font-size: 1.1em;
    max-width: 600px;
    margin: 0 auto;
}

.stats-row {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin: 30px 0;
    flex-wrap: wrap;
}

.stat-card {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 15px;
    padding: 25px 40px;
    text-align: center;
    min-width: 150px;
}

.stat-card .value {
    font-size: 2.5em;
    font-weight: bold;
    color: #00d4ff;
}

.stat-card .label {
    color: #888;
    margin-top: 5px;
}

.section-title {
    font-size: 1.5em;
    margin: 40px 0 20px;
    padding-bottom: 10px;
    border-bottom: 2px solid #00d4ff;
    display: inline-block;
}

.grid-2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 25px;
    margin-bottom: 25px;
}

.card {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 15px;
    padding: 20px;
    transition: transform 0.3s, box-shadow 0.3s;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 40px rgba(0,212,255,0.2);
}

.card h3 {
    color: #00d4ff;
    margin-bottom: 15px;
    font-size: 1.1em;
}

.card p {
    color: #888;
    font-size: 0.9em;
    margin-bottom: 15px;
}

.plot-container {
    background: #fff;
    border-radius: 10px;
    padding: 10px;
    min-height: 400px;
}

.full-width {
    grid-column: 1 / -1;
}

.population-legend {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
    margin: 20px 0;
}

.pop-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.9em;
}

.pop-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
}

.footer {
    text-align: center;
    padding: 30px;
    color: #666;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: 50px;
}

@media (max-width: 900px) {
    .grid-2 { grid-template-columns: 1fr; }
    .navbar { flex-direction: column; gap: 15px; }
    .navbar nav a { margin: 0 15px; }
}
EOF

# === JavaScript ===
cat << 'EOF' > webapp/static/js/plots.js
// Color palette for populations
const popColors = {
    'YRI': '#e74c3c',
    'LWK': '#3498db', 
    'GWD': '#2ecc71',
    'MSL': '#9b59b6',
    'ESN': '#f39c12'
};

const popNames = {
    'YRI': 'Yoruba (Nigeria)',
    'LWK': 'Luhya (Kenya)',
    'GWD': 'Gambian',
    'MSL': 'Mende (Sierra Leone)',
    'ESN': 'Esan (Nigeria)'
};

function createPCAPlot(data, elementId) {
    const traces = [];
    const populations = [...new Set(data.map(d => d.pop))];
    
    populations.forEach(pop => {
        const popData = data.filter(d => d.pop === pop);
        traces.push({
            x: popData.map(d => d.pc1),
            y: popData.map(d => d.pc2),
            mode: 'markers',
            type: 'scatter',
            name: popNames[pop] || pop,
            text: popData.map(d => d.sample),
            hovertemplate: '<b>%{text}</b><br>PC1: %{x:.4f}<br>PC2: %{y:.4f}<extra>' + pop + '</extra>',
            marker: {
                size: 10,
                color: popColors[pop] || '#999',
                opacity: 0.8,
                line: { width: 1, color: '#fff' }
            }
        });
    });

    const layout = {
        title: { text: 'Principal Component Analysis', font: { size: 18 } },
        xaxis: { title: 'PC1', gridcolor: '#eee' },
        yaxis: { title: 'PC2', gridcolor: '#eee' },
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        hovermode: 'closest',
        legend: { orientation: 'h', y: -0.2 }
    };

    Plotly.newPlot(elementId, traces, layout, {responsive: true});
}

function createFSTHeatmap(matrix, populations, elementId) {
    const trace = {
        z: matrix,
        x: populations.map(p => popNames[p] || p),
        y: populations.map(p => popNames[p] || p),
        type: 'heatmap',
        colorscale: 'Blues',
        hoverongaps: false,
        hovertemplate: '%{y} vs %{x}<br>FST: %{z:.4f}<extra></extra>',
        showscale: true,
        colorbar: { title: 'FST' }
    };

    // Add text annotations
    const annotations = [];
    for (let i = 0; i < populations.length; i++) {
        for (let j = 0; j < populations.length; j++) {
            annotations.push({
                x: popNames[populations[j]] || populations[j],
                y: popNames[populations[i]] || populations[i],
                text: matrix[i][j].toFixed(4),
                showarrow: false,
                font: { color: matrix[i][j] > 0.005 ? '#fff' : '#000', size: 11 }
            });
        }
    }

    const layout = {
        title: { text: 'Population Differentiation (FST)', font: { size: 18 } },
        annotations: annotations,
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        xaxis: { tickangle: -45 },
        margin: { b: 120 }
    };

    Plotly.newPlot(elementId, [trace], layout, {responsive: true});
}

function createAFPlot(data, pop1, pop2, elementId) {
    const trace = {
        x: data.map(d => d[pop1]),
        y: data.map(d => d[pop2]),
        mode: 'markers',
        type: 'scatter',
        marker: {
            size: 5,
            color: '#3498db',
            opacity: 0.4
        },
        hovertemplate: pop1 + ': %{x:.3f}<br>' + pop2 + ': %{y:.3f}<extra></extra>'
    };

    const diagonal = {
        x: [0, 1],
        y: [0, 1],
        mode: 'lines',
        type: 'scatter',
        line: { dash: 'dash', color: '#e74c3c', width: 2 },
        name: 'x = y',
        hoverinfo: 'skip'
    };

    const layout = {
        title: { text: 'Allele Frequency Comparison', font: { size: 18 } },
        xaxis: { title: popNames[pop1] || pop1, range: [0, 1], gridcolor: '#eee' },
        yaxis: { title: popNames[pop2] || pop2, range: [0, 1], gridcolor: '#eee' },
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        showlegend: false,
        hovermode: 'closest'
    };

    Plotly.newPlot(elementId, [trace, diagonal], layout, {responsive: true});
}
EOF

# === HTML Template ===
cat << 'EOF' > webapp/templates/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>African Genomics Webtool</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
    <script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>
</head>
<body>
    <div class="navbar">
        <h1>🧬 African Genomics Webtool</h1>
        <nav>
            <a href="#overview" class="active">Overview</a>
            <a href="#pca">PCA</a>
            <a href="#fst">FST</a>
            <a href="#af">Allele Freq</a>
        </nav>
    </div>

    <div class="container">
        <section class="hero" id="overview">
            <h2>Exploring African Genetic Diversity</h2>
            <p>Interactive visualization of genomic variation across five African populations from the 1000 Genomes Project</p>
        </section>

        <div class="stats-row">
            <div class="stat-card">
                <div class="value">{{ n_samples }}</div>
                <div class="label">Individuals</div>
            </div>
            <div class="stat-card">
                <div class="value">5</div>
                <div class="label">Populations</div>
            </div>
            <div class="stat-card">
                <div class="value">{{ n_variants | int }}</div>
                <div class="label">Variants</div>
            </div>
            <div class="stat-card">
                <div class="value">Chr22</div>
                <div class="label">Region</div>
            </div>
        </div>

        <div class="population-legend">
            <div class="pop-item"><span class="pop-dot" style="background:#e74c3c"></span> Yoruba (Nigeria)</div>
            <div class="pop-item"><span class="pop-dot" style="background:#3498db"></span> Luhya (Kenya)</div>
            <div class="pop-item"><span class="pop-dot" style="background:#2ecc71"></span> Gambian</div>
            <div class="pop-item"><span class="pop-dot" style="background:#9b59b6"></span> Mende (Sierra Leone)</div>
            <div class="pop-item"><span class="pop-dot" style="background:#f39c12"></span> Esan (Nigeria)</div>
        </div>

        <h2 class="section-title" id="pca">Population Structure</h2>
        <div class="grid-2">
            <div class="card">
                <h3>Principal Component Analysis</h3>
                <p>PCA reduces genomic data to key axes of variation. Clusters indicate genetic similarity.</p>
                <div class="plot-container" id="pca-plot"></div>
            </div>
            <div class="card" id="fst">
                <h3>FST Heatmap</h3>
                <p>FST measures genetic differentiation between populations (0=identical, higher=more different).</p>
                <div class="plot-container" id="fst-plot"></div>
            </div>
        </div>

        <h2 class="section-title" id="af">Allele Frequencies</h2>
        <div class="card full-width">
            <h3>Population Comparison</h3>
            <p>Each point is a variant. Points on the diagonal have equal frequency in both populations.</p>
            <div style="margin-bottom: 15px;">
                <label>Compare: </label>
                <select id="pop1-select" onchange="updateAFPlot()">
                    <option value="YRI_AF">Yoruba (YRI)</option>
                    <option value="LWK_AF">Luhya (LWK)</option>
                    <option value="GWD_AF">Gambian (GWD)</option>
                    <option value="MSL_AF">Mende (MSL)</option>
                    <option value="ESN_AF">Esan (ESN)</option>
                </select>
                <span> vs </span>
                <select id="pop2-select" onchange="updateAFPlot()">
                    <option value="YRI_AF">Yoruba (YRI)</option>
                    <option value="LWK_AF" selected>Luhya (LWK)</option>
                    <option value="GWD_AF">Gambian (GWD)</option>
                    <option value="MSL_AF">Mende (MSL)</option>
                    <option value="ESN_AF">Esan (ESN)</option>
                </select>
            </div>
            <div class="plot-container" id="af-plot"></div>
        </div>
    </div>

    <footer class="footer">
        <p>Data source: 1000 Genomes Project Phase 3 | Built with Flask & Plotly</p>
        <p>GitHub: <a href="https://github.com/Djinho/African_Genomics_Webtool" style="color:#00d4ff">Djinho/African_Genomics_Webtool</a></p>
    </footer>

    <script src="{{ url_for('static', filename='js/plots.js') }}"></script>
    <script>
        // Data from Flask
        const pcaData = {{ pca_data | safe }};
        const fstMatrix = {{ fst_matrix | safe }};
        const fstPops = {{ fst_pops | safe }};
        const afData = {{ af_data | safe }};

        // Initialize plots
        createPCAPlot(pcaData, 'pca-plot');
        createFSTHeatmap(fstMatrix, fstPops, 'fst-plot');
        createAFPlot(afData, 'YRI_AF', 'LWK_AF', 'af-plot');

        function updateAFPlot() {
            const pop1 = document.getElementById('pop1-select').value;
            const pop2 = document.getElementById('pop2-select').value;
            createAFPlot(afData, pop1, pop2, 'af-plot');
        }
    </script>
</body>
</html>
EOF

# === Flask App ===
cat << 'EOF' > webapp/app.py
from flask import Flask, render_template
import pandas as pd
import json
import os

app = Flask(__name__)

@app.route('/')
def index():
    base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    # Load PCA data
    pca_path = os.path.join(base_path, 'results/admixture/african_pca_labeled.txt')
    pca_df = pd.read_csv(pca_path, sep=r'\s+', header=None,
                         names=['FID','IID','PC1','PC2','PC3','PC4','PC5',
                                'PC6','PC7','PC8','PC9','PC10','Population'])
    
    pca_data = [{'sample': row['IID'], 'pc1': row['PC1'], 'pc2': row['PC2'], 'pop': row['Population']} 
                for _, row in pca_df.iterrows()]
    
    # Load FST data
    populations = ['YRI', 'LWK', 'GWD', 'MSL', 'ESN']
    fst_matrix = [[0.0]*5 for _ in range(5)]
    
    fst_dir = os.path.join(base_path, 'results/fst')
    for f in os.listdir(fst_dir):
        if f.endswith('.weir.fst'):
            pair = f.replace('.weir.fst', '')
            pop1, pop2 = pair.split('_')
            if pop1 in populations and pop2 in populations:
                df = pd.read_csv(os.path.join(fst_dir, f), sep='\t')
                fst_vals = df['WEIR_AND_COCKERHAM_FST'].replace([float('inf'), float('-inf')], float('nan'))
                mean_fst = fst_vals.dropna().mean()
                if pd.notna(mean_fst):
                    i, j = populations.index(pop1), populations.index(pop2)
                    fst_matrix[i][j] = mean_fst
                    fst_matrix[j][i] = mean_fst
    
    # Load AF data
    af_path = os.path.join(base_path, 'results/combined_af.txt')
    af_df = pd.read_csv(af_path, sep='\t', nrows=10000)
    af_data = af_df[['YRI_AF', 'LWK_AF', 'GWD_AF', 'MSL_AF', 'ESN_AF']].to_dict('records')
    
    return render_template('index.html',
                          n_samples=len(pca_df),
                          n_variants=len(af_df),
                          pca_data=json.dumps(pca_data),
                          fst_matrix=json.dumps(fst_matrix),
                          fst_pops=json.dumps(populations),
                          af_data=json.dumps(af_data))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
EOF

echo ""
echo "========================================"
echo "Web App Rebuilt!"
echo "========================================"
echo ""
echo "Structure:"
ls -la webapp/
ls -la webapp/static/css/
ls -la webapp/static/js/
ls -la webapp/templates/
echo ""
echo "Run with:"
echo "  cd ~/African_Genomics_Webtool/webapp && python app.py"

#!/bin/bash
cd ~/African_Genomics_Webtool
mkdir -p webapp/static/css webapp/static/js webapp/templates

# === MAIN CSS ===
cat << 'EOF' > webapp/static/css/style.css
:root {
    --primary: #00d4ff;
    --secondary: #00ff88;
    --dark: #0a0a1a;
    --card-bg: rgba(255,255,255,0.03);
    --border: rgba(255,255,255,0.1);
}

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Segoe UI', system-ui, sans-serif;
    background: var(--dark);
    color: #fff;
    line-height: 1.6;
}

/* Navigation */
.navbar {
    position: fixed;
    top: 0;
    width: 100%;
    background: rgba(10,10,26,0.95);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid var(--border);
    z-index: 1000;
    padding: 0 40px;
}

.nav-content {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 70px;
}

.logo {
    font-size: 1.4em;
    font-weight: 700;
    color: var(--primary);
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 10px;
}

.logo span { font-size: 1.5em; }

.nav-links { display: flex; gap: 10px; }

.nav-links a {
    color: #888;
    text-decoration: none;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.3s;
    font-size: 0.95em;
}

.nav-links a:hover, .nav-links a.active {
    color: #fff;
    background: rgba(0,212,255,0.1);
}

/* Hero Section */
.hero {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 100px 20px;
    background: 
        radial-gradient(ellipse at 20% 80%, rgba(0,212,255,0.15) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 20%, rgba(0,255,136,0.1) 0%, transparent 50%),
        var(--dark);
}

.hero h1 {
    font-size: 3.5em;
    font-weight: 800;
    margin-bottom: 20px;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.hero p {
    font-size: 1.3em;
    color: #888;
    max-width: 600px;
    margin-bottom: 40px;
}

.hero-stats {
    display: flex;
    gap: 40px;
    margin-bottom: 50px;
}

.hero-stat {
    text-align: center;
}

.hero-stat .value {
    font-size: 3em;
    font-weight: 700;
    color: var(--primary);
}

.hero-stat .label {
    color: #666;
    font-size: 0.9em;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.cta-buttons {
    display: flex;
    gap: 20px;
}

.btn {
    padding: 14px 32px;
    border-radius: 10px;
    font-size: 1em;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s;
    cursor: pointer;
    border: none;
}

.btn-primary {
    background: linear-gradient(135deg, var(--primary), #0099cc);
    color: #000;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(0,212,255,0.3);
}

.btn-secondary {
    background: transparent;
    border: 2px solid var(--border);
    color: #fff;
}

.btn-secondary:hover {
    border-color: var(--primary);
    background: rgba(0,212,255,0.1);
}

/* Sections */
.section {
    padding: 100px 40px;
    max-width: 1400px;
    margin: 0 auto;
}

.section-header {
    text-align: center;
    margin-bottom: 60px;
}

.section-header h2 {
    font-size: 2.5em;
    margin-bottom: 15px;
}

.section-header p {
    color: #888;
    font-size: 1.1em;
    max-width: 600px;
    margin: 0 auto;
}

/* Population Cards */
.pop-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 20px;
    margin-bottom: 60px;
}

.pop-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 15px;
    padding: 25px;
    text-align: center;
    transition: all 0.3s;
}

.pop-card:hover {
    transform: translateY(-5px);
    border-color: var(--primary);
    box-shadow: 0 10px 40px rgba(0,212,255,0.1);
}

.pop-card .dot {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    margin: 0 auto 15px;
}

.pop-card h3 { font-size: 1.1em; margin-bottom: 5px; }
.pop-card .country { color: #888; font-size: 0.9em; }
.pop-card .count { color: var(--primary); font-size: 1.5em; font-weight: 700; margin-top: 10px; }

/* Analysis Cards */
.analysis-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 30px;
}

.analysis-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 20px;
    overflow: hidden;
    transition: all 0.3s;
}

.analysis-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

.analysis-card.full { grid-column: 1 / -1; }

.card-header {
    padding: 25px 30px;
    border-bottom: 1px solid var(--border);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.card-header h3 {
    font-size: 1.2em;
    display: flex;
    align-items: center;
    gap: 10px;
}

.card-header .icon {
    font-size: 1.3em;
}

.card-body { padding: 20px; }

.plot-container {
    background: #fff;
    border-radius: 12px;
    min-height: 450px;
}

/* Controls */
.controls {
    display: flex;
    gap: 15px;
    align-items: center;
    flex-wrap: wrap;
}

.control-group {
    display: flex;
    align-items: center;
    gap: 8px;
}

.control-group label {
    color: #888;
    font-size: 0.9em;
}

select {
    background: rgba(255,255,255,0.1);
    border: 1px solid var(--border);
    color: #fff;
    padding: 8px 15px;
    border-radius: 8px;
    font-size: 0.9em;
    cursor: pointer;
}

select:focus {
    outline: none;
    border-color: var(--primary);
}

/* Footer */
.footer {
    background: rgba(0,0,0,0.3);
    border-top: 1px solid var(--border);
    padding: 40px;
    text-align: center;
    color: #666;
}

.footer a {
    color: var(--primary);
    text-decoration: none;
}

.footer a:hover { text-decoration: underline; }

/* Responsive */
@media (max-width: 1000px) {
    .pop-grid { grid-template-columns: repeat(3, 1fr); }
    .analysis-grid { grid-template-columns: 1fr; }
    .hero h1 { font-size: 2.5em; }
}

@media (max-width: 600px) {
    .pop-grid { grid-template-columns: repeat(2, 1fr); }
    .navbar { padding: 0 20px; }
    .nav-links { display: none; }
    .hero-stats { flex-direction: column; gap: 20px; }
    .section { padding: 60px 20px; }
}
EOF

# === JAVASCRIPT ===
cat << 'EOF' > webapp/static/js/app.js
const COLORS = {
    YRI: '#e74c3c',
    LWK: '#3498db',
    GWD: '#2ecc71',
    MSL: '#9b59b6',
    ESN: '#f39c12'
};

const NAMES = {
    YRI: 'Yoruba',
    LWK: 'Luhya',
    GWD: 'Gambian',
    MSL: 'Mende',
    ESN: 'Esan'
};

const COUNTRIES = {
    YRI: 'Nigeria',
    LWK: 'Kenya',
    GWD: 'Gambia',
    MSL: 'Sierra Leone',
    ESN: 'Nigeria'
};

function initPCA(data) {
    const traces = {};
    data.forEach(d => {
        if (!traces[d.pop]) {
            traces[d.pop] = { x: [], y: [], text: [], name: NAMES[d.pop] || d.pop };
        }
        traces[d.pop].x.push(d.pc1);
        traces[d.pop].y.push(d.pc2);
        traces[d.pop].text.push(d.sample);
    });

    const plotData = Object.keys(traces).map(pop => ({
        ...traces[pop],
        mode: 'markers',
        type: 'scatter',
        marker: { size: 9, color: COLORS[pop], opacity: 0.8 },
        hovertemplate: '<b>%{text}</b><br>PC1: %{x:.3f}<br>PC2: %{y:.3f}<extra></extra>'
    }));

    Plotly.newPlot('pca-plot', plotData, {
        title: null,
        xaxis: { title: 'PC1', gridcolor: '#eee', zerolinecolor: '#ddd' },
        yaxis: { title: 'PC2', gridcolor: '#eee', zerolinecolor: '#ddd' },
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        margin: { t: 20, r: 20, b: 50, l: 50 },
        legend: { orientation: 'h', y: -0.15 },
        hovermode: 'closest'
    }, { responsive: true });
}

function initFST(matrix, pops) {
    const labels = pops.map(p => NAMES[p] || p);
    
    Plotly.newPlot('fst-plot', [{
        z: matrix,
        x: labels,
        y: labels,
        type: 'heatmap',
        colorscale: [
            [0, '#e8f4f8'],
            [0.5, '#00d4ff'],
            [1, '#0066cc']
        ],
        hovertemplate: '%{y} vs %{x}<br>FST: %{z:.4f}<extra></extra>',
        showscale: true,
        colorbar: { title: 'FST', titleside: 'right' }
    }], {
        title: null,
        annotations: matrix.flatMap((row, i) => 
            row.map((val, j) => ({
                x: labels[j], y: labels[i],
                text: val.toFixed(4),
                showarrow: false,
                font: { color: val > 0.006 ? '#fff' : '#000', size: 11 }
            }))
        ),
        xaxis: { tickangle: -45 },
        yaxis: { autorange: 'reversed' },
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        margin: { t: 20, r: 80, b: 80, l: 100 }
    }, { responsive: true });
}

function initAF(data, pop1, pop2) {
    Plotly.newPlot('af-plot', [
        {
            x: data.map(d => d[pop1]),
            y: data.map(d => d[pop2]),
            mode: 'markers',
            type: 'scatter',
            marker: { size: 4, color: '#3498db', opacity: 0.3 },
            hovertemplate: `${NAMES[pop1.replace('_AF','')]}: %{x:.3f}<br>${NAMES[pop2.replace('_AF','')]}: %{y:.3f}<extra></extra>`
        },
        {
            x: [0, 1], y: [0, 1],
            mode: 'lines',
            line: { dash: 'dash', color: '#e74c3c', width: 2 },
            hoverinfo: 'skip',
            showlegend: false
        }
    ], {
        title: null,
        xaxis: { title: NAMES[pop1.replace('_AF','')] + ' Allele Frequency', range: [0, 1], gridcolor: '#eee' },
        yaxis: { title: NAMES[pop2.replace('_AF','')] + ' Allele Frequency', range: [0, 1], gridcolor: '#eee' },
        plot_bgcolor: '#fff',
        paper_bgcolor: '#fff',
        margin: { t: 20, r: 20, b: 60, l: 60 },
        hovermode: 'closest'
    }, { responsive: true });
}

function updateAF() {
    const pop1 = document.getElementById('pop1').value;
    const pop2 = document.getElementById('pop2').value;
    initAF(window.afData, pop1, pop2);
}

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});
EOF

# === HTML TEMPLATE ===
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
    <nav class="navbar">
        <div class="nav-content">
            <a href="#" class="logo"><span>🧬</span> African Genomics</a>
            <div class="nav-links">
                <a href="#home" class="active">Home</a>
                <a href="#populations">Populations</a>
                <a href="#pca">PCA</a>
                <a href="#fst">FST</a>
                <a href="#frequencies">Frequencies</a>
            </div>
        </div>
    </nav>

    <section class="hero" id="home">
        <h1>African Genomics Webtool</h1>
        <p>Explore genetic diversity across five African populations using data from the 1000 Genomes Project</p>
        
        <div class="hero-stats">
            <div class="hero-stat">
                <div class="value">{{ n_samples }}</div>
                <div class="label">Individuals</div>
            </div>
            <div class="hero-stat">
                <div class="value">5</div>
                <div class="label">Populations</div>
            </div>
            <div class="hero-stat">
                <div class="value">{{ "{:,}".format(n_variants) }}</div>
                <div class="label">Variants</div>
            </div>
        </div>
        
        <div class="cta-buttons">
            <a href="#pca" class="btn btn-primary">View Analysis</a>
            <a href="https://github.com/Djinho/African_Genomics_Webtool" class="btn btn-secondary" target="_blank">GitHub</a>
        </div>
    </section>

    <section class="section" id="populations">
        <div class="section-header">
            <h2>Study Populations</h2>
            <p>Five African populations representing diverse genetic backgrounds across the continent</p>
        </div>
        
        <div class="pop-grid">
            <div class="pop-card">
                <div class="dot" style="background: #e74c3c"></div>
                <h3>YRI</h3>
                <div class="country">Yoruba, Nigeria</div>
                <div class="count">108</div>
            </div>
            <div class="pop-card">
                <div class="dot" style="background: #3498db"></div>
                <h3>LWK</h3>
                <div class="country">Luhya, Kenya</div>
                <div class="count">99</div>
            </div>
            <div class="pop-card">
                <div class="dot" style="background: #2ecc71"></div>
                <h3>GWD</h3>
                <div class="country">Gambian</div>
                <div class="count">113</div>
            </div>
            <div class="pop-card">
                <div class="dot" style="background: #9b59b6"></div>
                <h3>MSL</h3>
                <div class="country">Mende, Sierra Leone</div>
                <div class="count">85</div>
            </div>
            <div class="pop-card">
                <div class="dot" style="background: #f39c12"></div>
                <h3>ESN</h3>
                <div class="country">Esan, Nigeria</div>
                <div class="count">99</div>
            </div>
        </div>
    </section>

    <section class="section" id="pca">
        <div class="section-header">
            <h2>Population Structure</h2>
            <p>Principal Component Analysis reveals genetic clustering patterns</p>
        </div>
        
        <div class="analysis-grid">
            <div class="analysis-card">
                <div class="card-header">
                    <h3><span class="icon">📊</span> PCA Plot</h3>
                </div>
                <div class="card-body">
                    <div class="plot-container" id="pca-plot"></div>
                </div>
            </div>
            
            <div class="analysis-card" id="fst">
                <div class="card-header">
                    <h3><span class="icon">🔥</span> FST Heatmap</h3>
                </div>
                <div class="card-body">
                    <div class="plot-container" id="fst-plot"></div>
                </div>
            </div>
        </div>
    </section>

    <section class="section" id="frequencies">
        <div class="section-header">
            <h2>Allele Frequencies</h2>
            <p>Compare variant frequencies between populations</p>
        </div>
        
        <div class="analysis-grid">
            <div class="analysis-card full">
                <div class="card-header">
                    <h3><span class="icon">🧪</span> Frequency Comparison</h3>
                    <div class="controls">
                        <div class="control-group">
                            <label>X-axis:</label>
                            <select id="pop1" onchange="updateAF()">
                                <option value="YRI_AF">Yoruba (YRI)</option>
                                <option value="LWK_AF">Luhya (LWK)</option>
                                <option value="GWD_AF">Gambian (GWD)</option>
                                <option value="MSL_AF">Mende (MSL)</option>
                                <option value="ESN_AF">Esan (ESN)</option>
                            </select>
                        </div>
                        <div class="control-group">
                            <label>Y-axis:</label>
                            <select id="pop2" onchange="updateAF()">
                                <option value="YRI_AF">Yoruba (YRI)</option>
                                <option value="LWK_AF" selected>Luhya (LWK)</option>
                                <option value="GWD_AF">Gambian (GWD)</option>
                                <option value="MSL_AF">Mende (MSL)</option>
                                <option value="ESN_AF">Esan (ESN)</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="plot-container" id="af-plot"></div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <p>Data: <a href="https://www.internationalgenome.org/" target="_blank">1000 Genomes Project Phase 3</a> | 
           Built with Flask & Plotly | 
           <a href="https://github.com/Djinho/African_Genomics_Webtool" target="_blank">View on GitHub</a></p>
    </footer>

    <script src="{{ url_for('static', filename='js/app.js') }}"></script>
    <script>
        window.afData = {{ af_data | safe }};
        initPCA({{ pca_data | safe }});
        initFST({{ fst_matrix | safe }}, {{ fst_pops | safe }});
        initAF(window.afData, 'YRI_AF', 'LWK_AF');
    </script>
</body>
</html>
EOF

echo "Webapp polished! Run: cd ~/African_Genomics_Webtool/webapp && python app.py"
EOF

chmod +x 09_polish_webapp.sh
./09_polish_webapp.sh
cd webapp
python app.py


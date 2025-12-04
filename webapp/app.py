from flask import Flask, render_template, jsonify
import pandas as pd
import json
import os

app = Flask(__name__)

# Base path for data files
BASE_PATH = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Population metadata
POPULATIONS = {
    'YRI': {'name': 'Yoruba', 'location': 'Ibadan, Nigeria', 'color': '#e74c3c'},
    'LWK': {'name': 'Luhya', 'location': 'Webuye, Kenya', 'color': '#3498db'},
    'GWD': {'name': 'Gambian', 'location': 'Western Division, The Gambia', 'color': '#2ecc71'},
    'MSL': {'name': 'Mende', 'location': 'Sierra Leone', 'color': '#9b59b6'},
    'ESN': {'name': 'Esan', 'location': 'Nigeria', 'color': '#f39c12'}
}

def get_stats():
    """Get summary statistics for the dataset."""
    pca_path = os.path.join(BASE_PATH, 'results/admixture/african_pca_labeled.txt')
    af_path = os.path.join(BASE_PATH, 'results/combined_af.txt')

    pca_df = pd.read_csv(pca_path, sep=r'\s+', header=None)
    n_samples = len(pca_df)

    # Count total variants from combined_af
    with open(af_path, 'r') as f:
        n_variants = sum(1 for _ in f) - 1  # Subtract header

    return {
        'n_samples': n_samples,
        'n_populations': len(POPULATIONS),
        'n_variants': n_variants,
        'chromosome': 'chr22'
    }

def load_pca_data():
    """Load PCA data with population labels."""
    pca_path = os.path.join(BASE_PATH, 'results/admixture/african_pca_labeled.txt')
    pca_df = pd.read_csv(pca_path, sep=r'\s+', header=None,
                         names=['FID', 'IID', 'PC1', 'PC2', 'PC3', 'PC4', 'PC5',
                                'PC6', 'PC7', 'PC8', 'PC9', 'PC10', 'Population'])

    return [{'sample': row['IID'], 'pc1': row['PC1'], 'pc2': row['PC2'],
             'pc3': row['PC3'], 'pop': row['Population']}
            for _, row in pca_df.iterrows()]

def load_fst_data():
    """Load FST matrix between all population pairs."""
    populations = list(POPULATIONS.keys())
    fst_matrix = [[0.0] * 5 for _ in range(5)]
    fst_details = []

    fst_dir = os.path.join(BASE_PATH, 'results/fst')
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
                    fst_details.append({
                        'pop1': pop1,
                        'pop2': pop2,
                        'mean_fst': round(mean_fst, 6),
                        'n_variants': len(fst_vals.dropna())
                    })

    return {'matrix': fst_matrix, 'populations': populations, 'details': fst_details}

def load_af_data(limit=10000):
    """Load allele frequency data."""
    af_path = os.path.join(BASE_PATH, 'results/combined_af.txt')
    af_df = pd.read_csv(af_path, sep='\t', nrows=limit)

    return {
        'data': af_df[['CHROM', 'POS', 'REF', 'ALT', 'YRI_AF', 'LWK_AF', 'GWD_AF', 'MSL_AF', 'ESN_AF']].to_dict('records'),
        'populations': list(POPULATIONS.keys())
    }

# Routes
@app.route('/')
def home():
    """Landing page with overview."""
    stats = get_stats()
    return render_template('home.html',
                          stats=stats,
                          populations=POPULATIONS)

@app.route('/pca')
def pca():
    """PCA analysis page."""
    pca_data = load_pca_data()
    stats = get_stats()
    return render_template('pca.html',
                          pca_data=json.dumps(pca_data),
                          stats=stats,
                          populations=POPULATIONS)

@app.route('/fst')
def fst():
    """FST analysis page."""
    fst_data = load_fst_data()
    stats = get_stats()
    return render_template('fst.html',
                          fst_matrix=json.dumps(fst_data['matrix']),
                          fst_pops=json.dumps(fst_data['populations']),
                          fst_details=fst_data['details'],
                          stats=stats,
                          populations=POPULATIONS)

@app.route('/allele-frequency')
def allele_frequency():
    """Allele frequency analysis page."""
    af_data = load_af_data()
    stats = get_stats()
    return render_template('allele_frequency.html',
                          af_data=json.dumps(af_data['data']),
                          stats=stats,
                          populations=POPULATIONS)

@app.route('/api/stats')
def api_stats():
    """API endpoint for statistics."""
    return jsonify(get_stats())

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

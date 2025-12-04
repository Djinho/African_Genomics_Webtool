// Population color and name mappings
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

// Common Plotly layout settings for dark theme compatibility
const commonLayout = {
    plot_bgcolor: '#ffffff',
    paper_bgcolor: '#ffffff',
    font: { family: 'Inter, system-ui, sans-serif' },
    margin: { l: 60, r: 30, t: 50, b: 60 }
};

/**
 * Create a PCA scatter plot
 * @param {Array} data - Array of objects with sample, pc1, pc2, pc3, pop fields
 * @param {string} elementId - ID of the container element
 * @param {string} xAxis - Which PC to use for x-axis (pc1, pc2, pc3)
 * @param {string} yAxis - Which PC to use for y-axis (pc1, pc2, pc3)
 * @param {Object} populations - Population metadata from Flask
 */
function createPCAPlot(data, elementId, xAxis = 'pc1', yAxis = 'pc2', populations = null) {
    const traces = [];
    const uniquePops = [...new Set(data.map(d => d.pop))];

    uniquePops.forEach(pop => {
        const popData = data.filter(d => d.pop === pop);
        const color = populations ? populations[pop]?.color : popColors[pop];
        const name = populations ? `${populations[pop]?.name} (${pop})` : (popNames[pop] || pop);

        traces.push({
            x: popData.map(d => d[xAxis]),
            y: popData.map(d => d[yAxis]),
            mode: 'markers',
            type: 'scatter',
            name: name,
            text: popData.map(d => d.sample),
            hovertemplate: `<b>%{text}</b><br>${xAxis.toUpperCase()}: %{x:.4f}<br>${yAxis.toUpperCase()}: %{y:.4f}<extra>${pop}</extra>`,
            marker: {
                size: 10,
                color: color || '#999',
                opacity: 0.85,
                line: { width: 1, color: '#fff' }
            }
        });
    });

    const axisLabels = {
        'pc1': 'PC1',
        'pc2': 'PC2',
        'pc3': 'PC3'
    };

    const layout = {
        ...commonLayout,
        title: {
            text: `Principal Component Analysis (${axisLabels[xAxis]} vs ${axisLabels[yAxis]})`,
            font: { size: 16, color: '#333' }
        },
        xaxis: {
            title: { text: axisLabels[xAxis], font: { size: 14 } },
            gridcolor: '#eee',
            zerolinecolor: '#ddd'
        },
        yaxis: {
            title: { text: axisLabels[yAxis], font: { size: 14 } },
            gridcolor: '#eee',
            zerolinecolor: '#ddd'
        },
        hovermode: 'closest',
        legend: {
            orientation: 'h',
            y: -0.15,
            x: 0.5,
            xanchor: 'center'
        }
    };

    const config = {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d'],
        displaylogo: false
    };

    Plotly.newPlot(elementId, traces, layout, config);
}

/**
 * Create an FST heatmap
 * @param {Array} matrix - 2D array of FST values
 * @param {Array} pops - Array of population codes
 * @param {string} elementId - ID of the container element
 * @param {Object} populations - Population metadata from Flask
 */
function createFSTHeatmap(matrix, pops, elementId, populations = null) {
    const labels = pops.map(p => {
        if (populations && populations[p]) {
            return populations[p].name;
        }
        return popNames[p] || p;
    });

    const trace = {
        z: matrix,
        x: labels,
        y: labels,
        type: 'heatmap',
        colorscale: [
            [0, '#e8f4f8'],
            [0.25, '#b3d9e6'],
            [0.5, '#4fa3c7'],
            [0.75, '#2980b9'],
            [1, '#1a5276']
        ],
        hoverongaps: false,
        hovertemplate: '%{y} vs %{x}<br>FST: %{z:.4f}<extra></extra>',
        showscale: true,
        colorbar: {
            title: { text: 'FST', font: { size: 12 } },
            tickfont: { size: 11 }
        }
    };

    // Add text annotations for FST values
    const annotations = [];
    for (let i = 0; i < pops.length; i++) {
        for (let j = 0; j < pops.length; j++) {
            annotations.push({
                x: labels[j],
                y: labels[i],
                text: matrix[i][j].toFixed(4),
                showarrow: false,
                font: {
                    color: matrix[i][j] > 0.006 ? '#fff' : '#333',
                    size: 11
                }
            });
        }
    }

    const layout = {
        ...commonLayout,
        title: {
            text: 'Population Differentiation (FST)',
            font: { size: 16, color: '#333' }
        },
        annotations: annotations,
        xaxis: {
            tickangle: -45,
            tickfont: { size: 11 }
        },
        yaxis: {
            tickfont: { size: 11 }
        },
        margin: { l: 120, r: 80, t: 50, b: 120 }
    };

    const config = {
        responsive: true,
        displayModeBar: true,
        displaylogo: false
    };

    Plotly.newPlot(elementId, [trace], layout, config);
}

/**
 * Create an allele frequency comparison scatter plot
 * @param {Array} data - Array of objects with population AF fields
 * @param {string} pop1 - First population column (e.g., 'YRI_AF')
 * @param {string} pop2 - Second population column (e.g., 'LWK_AF')
 * @param {string} elementId - ID of the container element
 * @param {Object} populations - Population metadata from Flask
 */
function createAFPlot(data, pop1, pop2, elementId, populations = null) {
    // Extract population codes from column names
    const pop1Code = pop1.replace('_AF', '');
    const pop2Code = pop2.replace('_AF', '');

    const pop1Name = populations ? populations[pop1Code]?.name : popNames[pop1Code];
    const pop2Name = populations ? populations[pop2Code]?.name : popNames[pop2Code];
    const pop1Color = populations ? populations[pop1Code]?.color : popColors[pop1Code];

    // Main scatter trace
    const scatter = {
        x: data.map(d => d[pop1]),
        y: data.map(d => d[pop2]),
        mode: 'markers',
        type: 'scatter',
        name: 'Variants',
        hovertemplate: `${pop1Name}: %{x:.3f}<br>${pop2Name}: %{y:.3f}<extra></extra>`,
        marker: {
            size: 4,
            color: pop1Color || '#3498db',
            opacity: 0.4
        }
    };

    // Diagonal reference line (x = y)
    const diagonal = {
        x: [0, 1],
        y: [0, 1],
        mode: 'lines',
        type: 'scatter',
        name: 'Equal frequency',
        line: {
            dash: 'dash',
            color: '#e74c3c',
            width: 2
        },
        hoverinfo: 'skip'
    };

    const layout = {
        ...commonLayout,
        title: {
            text: `Allele Frequency: ${pop1Name} vs ${pop2Name}`,
            font: { size: 16, color: '#333' }
        },
        xaxis: {
            title: { text: `${pop1Name} (${pop1Code})`, font: { size: 14 } },
            range: [-0.02, 1.02],
            gridcolor: '#eee',
            zerolinecolor: '#ddd'
        },
        yaxis: {
            title: { text: `${pop2Name} (${pop2Code})`, font: { size: 14 } },
            range: [-0.02, 1.02],
            gridcolor: '#eee',
            zerolinecolor: '#ddd'
        },
        showlegend: false,
        hovermode: 'closest'
    };

    const config = {
        responsive: true,
        displayModeBar: true,
        modeBarButtonsToRemove: ['lasso2d', 'select2d'],
        displaylogo: false
    };

    Plotly.newPlot(elementId, [scatter, diagonal], layout, config);
}

// Export functions for use in other modules if needed
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { createPCAPlot, createFSTHeatmap, createAFPlot };
}

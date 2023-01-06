export default {
    id: 'waterway_label',
    type: 'symbol',
    minzoom: 12,
    filter: ['==', ['get', 'waterway'], 'river'],
    source: 'baremaps',
    'source-layer': 'waterway',
    layout: {
        visibility: 'visible',
        'text-font': ['Noto Sans Italic'],
        'text-field': ['get', 'name'],
        'text-size': [
            'interpolate',
            ['exponential', 1.2],
            ['zoom'],
            12,
            9,
            15,
            12,
            18,
            11,
        ],
        'symbol-placement': 'line',
    },
    paint: {
        'text-color': 'rgba(26, 109, 187, 1)',
        'text-halo-color': 'rgba(255, 255, 255, 0.8)',
        'text-halo-width': 1.2,
    },
}
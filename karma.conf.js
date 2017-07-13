module.exports = (config) => {
    config.set({
        autoWatch: true,
        singleRun: true,
        browsers: ['Chrome'],
        files: [
            'dist/karma/worker01.js',
            'dist/karma/index.js',
        ],
        frameworks: [
            'mocha',
        ],
        plugins: [
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-spec-reporter',
            'karma-mocha',
        ],
        reporters: ['spec'],
        client: {
            mocha: {
                timeout: 10000,
            },
        },
    });
};

module.exports = (config) => {
    config.set({
        autoWatch: true,
        singleRun: true,
        browsers: ['Chrome'],
        files: [
            'dist/karma/index.js',
            {
                watched: false,
                pattern: 'dist/karma/worker*.js',
                included: false,
                served: true,
            },
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
                timeout: 1000,
            },
        },
    });
};

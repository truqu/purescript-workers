module.exports = (config) => {
    config.set({
        browsers: [
            'FirefoxMAC',
            'ChromeMAC',
            // 'SafariMAC',
            'OperaMAC',

            'FirefoxWIN',
            'ChromeWIN',
            'OperaWIN',
        ],
        files: [
            'dist/karma/index.js',
        ],
        frameworks: [
            'mocha',
        ],
        plugins: [
            'karma-browserstack-launcher',
            'karma-mocha',
        ],
        reporters: [
            'dots',
            'BrowserStack',
        ],
        singleRun: true,
        client: {
            mocha: {
                timeout: 10000,
            },
        },
        browserStack: {
            username: process.env.BROWSERSTACK_USERNAME,
            accessKey: process.env.BROWSERSTACK_ACCESSKEY,
            timeout: 1500,
            captureTimeout: 500,
        },
        customLaunchers: {
            FirefoxMAC: {
                base: 'BrowserStack',
                browser: 'Firefox',
                browser_version: '51',
                os: 'OS X',
                os_version: 'Sierra',
            },
            ChromeMAC: {
                base: 'BrowserStack',
                browser: 'Chrome',
                browser_version: '58',
                os: 'OS X',
                os_version: 'Sierra',
            },
            SafariMAC: {
                base: 'BrowserStack',
                browser: 'Safari',
                browser_version: '10.1',
                os: 'OS X',
                os_version: 'Sierra',
            },
            OperaMAC: {
                base: 'BrowserStack',
                browser: 'Opera',
                browser_version: '46',
                os: 'OS X',
                os_version: 'Sierra',
            },
            FirefoxWIN: {
                base: 'BrowserStack',
                browser: 'Firefox',
                browser_version: '51',
                os: 'WINDOWS',
                os_version: '10',
            },
            ChromeWIN: {
                base: 'BrowserStack',
                browser: 'Chrome',
                browser_version: '58',
                os: 'WINDOWS',
                os_version: '10',
            },
            OperaWIN: {
                base: 'BrowserStack',
                browser: 'Opera',
                browser_version: '46',
                os: 'WINDOWS',
                os_version: '10',
            },
        },
    });
};

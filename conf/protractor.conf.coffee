SpecReporter = require('jasmine-spec-reporter')
jasmineReporter = require('jasmine-reporters')

exports.config =
  # seleniumServerJar:  './node_modules/protractor/selenium/selenium-server-standalone-2.48.2.jar'
  # seleniumAddress: 'http://localhost:4444/wd/hub'
  # baseUrl: "http://localhost:9000"

  # specs: [
  #   'spec/e2e/e2eSpec.cofee'
  # ]

  # chromeDriver: './node_modules/protractor/selenium/chromedriver'
  directConnect: true

  capabilities:
    browserName: 'chrome'
    chromeOptions:
        args: [
            '--disable-cache',
            '--disable-application-cache',
            '--disable-offline-load-stale-cache',
            '--disk-cache-size=0',
            '--v8-cache-options=off'
        ]


  framework: 'jasmine2'

  jasmineNodeOpts:
    showColors: true
    isVerbose: true
    defaultTimeoutInterval: 30000

  onPrepare: ->
    jasmine.getEnv().addReporter new SpecReporter(displayStacktrace: true)
    jasmine.getEnv().addReporter new jasmineReporter.JUnitXmlReporter(
      savePath: __dirname + '/../result/junit'
      consolidateAll: false
      )
    return

  # plugins: [
  #   "protractor-coffee-preprocessor"
  # ]
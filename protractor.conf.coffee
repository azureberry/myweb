SpecReporter = require('jasmine-spec-reporter')

exports.config =
  #   seleniumServerJar:  './node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar'
  # seleniumAddress: 'http://localhost:4444/wd/hub'
  # baseUrl: "http://localhost:9000"

  # specs: [
  #   'spec/e2e/e2eSpec.cofee'
  # ]

  capabilities:
    browserName: 'chrome'

  framework: 'jasmine2'

  jasmineNodeOpts:
    showColors: true
    isVerbose: true
    defaultTimeoutInterval: 30000

  onPrepare: ->
    reporter = new SpecReporter(displayStacktrace: true)
    jasmine.getEnv().addReporter reporter
    return

  # plugins: [
  #   "protractor-coffee-preprocessor"
  # ]
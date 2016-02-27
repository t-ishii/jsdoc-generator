{CompositeDisposable} = require 'atom'

generator = null
Generator = null

module.exports = Main =

  # settings
  config:
    debugMode:
      type: 'boolean'
      default: false
      description: 'output log'
    outputDirectory:
      type: 'string'
      default: '{pwd}/out'
      description: "relative path starts from `#{process.cwd()}`"
    options:
      type: 'string'
      default: 'none'
      description: 'example) `--debug --nocolor`'

  subscriptions: null

  activate: (state) ->

    @subscriptions = new CompositeDisposable()

    @subscriptions.add atom.commands.add(
      'atom-workspace',
      'jsdoc-generator:out': =>
        @loadModule()
        generator.execute('editor')
      'jsdoc-generator:out-tree': =>
        @loadModule()
        generator.execute('tree')
    )

  deactivate: ->
    @subscriptions.dispose()

  loadModule: ->
    Generator ?= require './generator'
    generator ?= new Generator()

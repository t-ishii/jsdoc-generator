{CompositeDisposable} = require 'atom'

generator = null
Generator = null

module.exports = Main =

  config:
    debugMode:
      type: 'boolean'
      default: false
    outputDirectory:
      type: 'string'
      default: './out'
    options:
      type: 'string'
      default: 'none'
      description: '--verbose, --test, -X, etc...'

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

{$, BufferedProcess} = require 'atom'

path = require 'path'

module.exports =
class Generator

  ###
  get active editor path
  @return {String} active editor path
  ###
  getActiveEditorPath: ->
    atom.workspace.getActiveTextEditor()?.getPath()

  ###
  get selected file/dir
  @return {String} src
  ###
  getSelectedItemPath: ->
    # bug: don't multi select file/dir
    selectedItem = $('.selected', $('.tree-view')).get(0)

    if 'directory' in selectedItem.classList
      src = selectedItem.directoryName.dataset.path
    else
      src = selectedItem.file.path

    return src

  ###
  gen jsdoc
  @param {String} actName
  ###
  execute: (actName) ->

    isDebug = atom.config.get('jsdoc-generator.debugMode')

    switch actName
      when 'tree' then src = @getSelectedItemPath()
      when 'editor' then src = @getActiveEditorPath()

    outDir = atom.config.get('jsdoc-generator.outputDirectory')

    if outDir is './out'
      args = ['-d', path.join(path.dirname(src), 'out')]
    else
      args = ['-d', outDir]

    opt = atom.config.get('jsdoc-generator.options')

    args.push(opt) if opt isnt 'none'

    args.push(src)

    console.log args

    new BufferedProcess({

      command: path.join(
        atom.packages.resolvePackagePath('jsdoc-view'),
        'node_modules',
        '.bin',
        'jsdoc'
      )

      args: args

      stdout: (output) ->
        console.log output if isDebug

      stderr: (output) ->
        console.log output if isDebug

        # show error
        console.error output
        atom.notifications?.addError output

      exit: (exitCode) ->
        console.log exitCode if isDebug

        if exitCode is 0
          atom.notifications?.addSuccess 'jsdoc-generator: Complete!'
  })

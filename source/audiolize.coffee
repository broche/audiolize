globals = exports ? this

globals.audiolize ?= {}

class globals.audiolize.Audiolizer
  constructor: (options) ->
    @audio = {}
    @audio.context = new globals.webkitAudioContext()
    @audio.source = @audio.context.createBufferSource()
    @audio.analyzer = @audio.context.createAnalyser()
    @audio.analyzer.fftSize = 1024
    @audio.source.connect @audio.analyzer
    @audio.analyzer.connect @audio.context.destination

    @renderers = []

    @clearColor = options.clearColor ? 0x000000
    @autoClear = no

    @loop = options.loop ? no

  setBuffer: (buffer, mixToMono = no) ->
    @audio.source.buffer = @audio.context.createBuffer buffer, mixToMono

  play: ->
    @audio.source.noteOn 0
    @visualizationData = {}
    @visualizationData.frequency = new Uint8Array @audio.analyzer.frequencyBinCount
    @visualizationData.time = new Uint8Array @audio.analyzer.frequencyBinCount
    @update()

  update: ->
    @audio.analyzer.smoothingTimeConstant = 0.1
    @audio.analyzer.getByteFrequencyData @visualizationData.frequency
    @audio.analyzer.getByteTimeDomainData @visualizationData.time
    for renderer in @renderers
      renderer.update?()

  clear: ->
    canvas = document.getElementById @canvasID
    context = canvas.getContext "2d"
    context.beginPath()
    context.rect 0, 0, canvas.width, canvas.height
    context.fillStyle = "##{@clearColor.toString 16}"
    context.fill()

  render: ->
    return if not @canvasID?

    @clear() if @autoClear is on
    canvas = document.getElementByID @canvasID
    for renderer in @renderers
      renderer.render canvas, @visualizationData
globals = exports ? this

globals.audiolize ?= {}
globals.audiolize.renderers ?= {}

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

    @playing = no

  setBuffer: (buffer, mixToMono = no) ->
    @audio.source.buffer = @audio.context.createBuffer buffer, mixToMono

  addRenderer: (renderer) ->
    @renderers.push renderer

  play: ->
    @audio.source.noteOn 0
    @playing = yes
    @visualizationData = {}
    @visualizationData.frequency = new Uint8Array @audio.analyzer.frequencyBinCount
    @visualizationData.time = new Uint8Array @audio.analyzer.frequencyBinCount
    @update()

  stop: ->
    @audio.source.noteOff 0
    @playing = no

  update: ->
    return unless @playing
    @audio.analyzer.smoothingTimeConstant = 0.1
    @audio.analyzer.getByteFrequencyData @visualizationData.frequency
    @audio.analyzer.getByteTimeDomainData @visualizationData.time
    for renderer in @renderers
      renderer.update? @visualizationData

  clear: ->
    canvas = document.getElementById @canvasID
    context = canvas.getContext "2d"
    context.beginPath()
    context.rect 0, 0, canvas.width, canvas.height
    context.fillStyle = "##{@clearColor.toString 16}"
    context.fill()

  render: ->
    return if not @canvasID? or not @playing

    @clear() if @autoClear is on
    canvas = document.getElementById @canvasID
    for renderer in @renderers
      renderer.render canvas, @visualizationData
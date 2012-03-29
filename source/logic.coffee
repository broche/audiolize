# Canvas to draw on
visualCanvas = null

# Audio related variables
audioContext = analyser = source = window.freqByteData = timeByteData = audioBuffer = null
window.averages = []

# The current mouse position
posX = posY = 250

# yes if at least one song has already been loaded
already = no

window.mousePositions = []
window.colors = [
  "#1F6CA3"
  "#1F6CA3"
  "#1F6CA3"
  "#6397BB"
  "#6397BB"
  "#6397BB"
	"#5DB8F8"
  "#5DB8F8"
  "#5DB8F8"
  "#87CBFC"
  "#87CBFC"
  "#87CBFC"
	"#A7D9FC"
  "#A7D9FC"
  "#A7D9FC"
]

mouseDown = no

# Signals to the step loop if a new song has been selected to stop
# visulaization.
songChange = no

# Flag for drawing squares or circles
window.circles = yes

window.previousFrequencyData = []

window.requestAnimFrame =
  window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame or
  window.oRequestAnimationFrame or
  window.msRequestAnimationFrame or
  (callback) ->
    window.setTimeout callback, 5000 / 60

window.onload = ->
  # Initialize the canvas variables.
  visualCanvas = $("#music")[0]
  ctx = visualCanvas.getContext "2d"

  # Display song selection prompt.
  ctx.font = "15pt Century Gothic"
  ctx.fillText "choose a song below...", 140, 250

  initializeEvents()

  # Make a web audio context to play sounds.
  audioContext = new window.webkitAudioContext()

initializeEvents = ->
  $("#music").mousemove (e) ->
    posX = e.pageX - @offsetLeft
    posY = e.pageY - @offsetTop
    mousePositions.push [posX, posY]
  $("#music").mousedown ->
    mouseDown = yes
    window.circles = !circles
  $("#music").mouseup ->
    mouseDown = no
  $("#song_select").children().click ->
    if not already
      ctx = visualCanvas.getContext "2d"
      ctx.clearRect 0, 0, 500, 500
      ctx.font = "15pt Century Gothic"
      ctx.fillStyle = "red"
      ctx.fillText "loading song...", 175, 250
      already = yes
      $("#song_id").html @alt
      songUrl = "sounds/#{@id}.ogg"
      loadAudio songUrl
    else
      source.buffer = audioBuffer
      source.noteOff 0
      songChange = yes
      $("#song_id").html @alt
      songUrl = "sounds/#{@id}.ogg"
  $("#song_select").children().mouseover ->
    if not already then $("#song_id").html @alt
  $("#song_select").children().mouseleave ->
    if not already then $("#song_id").html "song info"

loadAudio = (url) ->
  # Create a buffer for the audio.
  source = audioContext.createBufferSource()

  # Create an analyzer for the audio.
  analyser = audioContext.createAnalyser()
  analyser.fftSize = 1024

  # Connect the buffer source to the analyzer.
  source.connect analyser

  # Then connect the analyzer to the speakers
  analyser.connect audioContext.destination

  # Load the chosen song.
  loadAudioBuffer url

loadAudioBuffer = (url) ->
  # Load asynchronously.
  request = new XMLHttpRequest()
  request.open "GET", url, true
  request.responseType = "arraybuffer"

  request.onload = ->
    # Create a buffer for the audio that was brought in.
    audioBuffer = audioContext.createBuffer request.response, false
    audioLoaded()
  request.send()

audioLoaded = ->
  songChange = no
  ctx = visualCanvas.getContext "2d"
  ctx.clearRect 0, 0, 500, 500

  # Connect the audio buffer to the source buffer.
  source.buffer = audioBuffer
  source.loop = on
  # Start the audio now.
  source.noteOn 0

  # Initialize the two arrays that will store frequency and time data.
  window.freqByteData = new Uint8Array analyser.frequencyBinCount
  timeByteData = new Uint8Array analyser.frequencyBinCount

  # Begin the visualizer.
  console.log $("#renderer")[0].value
  switch +$("#renderer")[0].value
    when 1 then step visualCanvas, mainRender
    when 2 then step visualCanvas, layeredRender
    else step visualCanvas, mainRender

step = (canvas, renderCallback) ->
  updateAnalyserData()
  updatePreviousFrequencyData()
  renderCallback canvas, getAverageFrequency()

  # If the user clicked on any song while the visualizer is running, this flag
  # is set so that a loading message is drawn to the screen and the animation
  # stops until the new song is loaded.
  if songChange
    ctx = canvas.getContext "2d"
    ctx.clearRect 0, 0, 500, 500
    ctx.font = "15pt Century Gothic"
    ctx.fillStyle = "red"
    ctx.fillText "loading song...", 175, 250
  else
    requestAnimFrame ->
      step canvas, renderCallback

updateAnalyserData = ->
  # Obtain the most recent time and frequency data.
  analyser.smoothingTimeConstant = 0.1
  analyser.getByteFrequencyData window.freqByteData
  analyser.getByteTimeDomainData timeByteData

getAverageFrequency = ->
  length = window.freqByteData.length
  sum = 0
  for i in [0...length]
    sum += window.freqByteData[i]
  sum / length
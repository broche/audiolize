globals = exports ? this

stage = null
currentSongId = null

$ ->
  initializeEvents()
  showWelcomeScreen $("#visualStage")[0]
  #setTimeout ->
    #stage.stop()
 # , 30 * 1000

init = (audioPath) ->
  stage = new audiolize.Audiolizer loop: off, clearColor: 0xAAAAAA
  stage.autoClear = on
  stage.canvasID = "visualStage"

  if stage.renderers.length is 0
    findRenderers parseInt $("#renderer")[0].value

  request = new XMLHttpRequest()
  request.open "GET", audioPath, true
  request.responseType = "arraybuffer"
  request.onload = ->
    stage.setBuffer request.response
    stage.play()
    animate()
  request.send()

animate = ->
  stage.update()
  render()
  requestAnimationFrame animate if stage.playing

render = ->
  stage.render()

initializeEvents = ->
  $("#song_select").children().click ->
    if stage? then stage.stop()
    $("#song_id").html @alt
    songUrl = "sounds/" + @id + ".ogg"
    currentSongId = @alt
    showLoadingScreen $("#visualStage")[0]
    init songUrl
  .mouseover ->
    $("#song_id").html @alt
  .mouseleave ->
    $("#song_id").html currentSongId

  $("#renderer").change ->
    if stage? then findRenderers parseInt @value

showWelcomeScreen = (canvas) ->
  ctx = canvas.getContext "2d"
  ctx.font = "20pt Century Gothic"
  ctx.fillStyle = "red"
  ctx.textAlign = "center"
  ctx.fillText "choose song below", canvas.width / 2, canvas.height / 2 - 25
  ctx.font = "10pt Century Gothic"
  ctx.fillStyle = "black"
  ctx.fillText "to change renderer, use menu in upper left corner", canvas.width / 2, canvas.height / 2

showLoadingScreen = (canvas) ->
  ctx = canvas.getContext "2d"
  ctx.clearRect 0, 0, canvas.width, canvas.height
  ctx.font = "15pt Century Gothic"
  ctx.fillStyle = "red"
  ctx.textAlign = "center"
  ctx.fillText "loading song...", canvas.width / 2, canvas.height / 2 -25
  ctx.font = "8pt Century Gothic"
  ctx.fillStyle = "black"
  ctx.textAlign = "center"
  ctx.fillText "if the song doesn't load after 10 seconds, refresh the page", canvas.width / 2, canvas.height / 2

findRenderers = (value)->
  switch value
    when 1
      addRenderers [audiolize.renderers.hills, audiolize.renderers.circles, audiolize.renderers.lines]
      audiolize.renderers.circles.addHandler "visualStage"
    when 2 then addRenderers [audiolize.renderers.layered]
    when 3 then addRenderers [audiolize.renderers.equalizer]
    when 4
      addRenderers [audiolize.renderers.circles]
      audiolize.renderers.circles.addHandler "visualStage"
    when 5 then addRenderers [audiolize.renderers.hills]
    when 6 then addRenderers [audiolize.renderers.lines]

addRenderers = (renderers) ->
  stage.renderers.splice 0
  for renderer in renderers
    stage.addRenderer renderer

globals = exports ? this

stage = null

$ ->
  init()
  setTimeout ->
    stage.stop()
  , 30 * 1000

init = ->
  stage = new audiolize.Audiolizer loop: off, clearColor: 0xAAAAAA
  stage.autoClear = on
  stage.canvasID = "music"
  stage.addRenderer audiolize.renderers.equalizer

  request = new XMLHttpRequest()
  request.open "GET", "sounds/Sanxion7 - EternuS (Remastered).ogg", true
  request.responseType = "arraybuffer"
  request.onload = ->
    stage.setBuffer request.response
    stage.play()
    animate()
  request.send()

animate = ->
  stage.update()
  render()

  requestAnimationFrame animate

render = ->
  stage.render()
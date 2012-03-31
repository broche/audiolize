globals = exports ? this

stage = null

init = ->
  stage = new audiolize.Audiolizer loop: off
  stage.autoClear = yes
  request = new XMLHttpRequest()
  request.open "GET", "sounds/Sanxion7 - EternuS (Remastered).ogg", true
  request.responseType = "arraybuffer"
  request.onload = ->
    stage.setBuffer request.response
    stage.play()
    animate()
  request.send()

animate = ->
  # console.log "animating"
  stage.update()
  render()

  requestAnimationFrame animate

render = ->
  # console.log "rendering"
  stage.render()

$ ->
  init()
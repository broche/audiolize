globals = exports ? this

visualizer = new audiolize.Audiolizer loop: on

request = new XMLHttpRequest()
request.open "GET", "sounds/booty.ogg", true
request.responseType = "arraybuffer"
request.onload = ->
  visualizer.setBuffer request.response
  visualizer.play()
request.send()

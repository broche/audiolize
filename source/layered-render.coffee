globals = exports ? this

globals.layeredRender = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  ctx.clearRect 0, 0, canvas.width, canvas.height

  drawPastFrequencyGraphs canvas

globals.updatePreviousFrequencyData = ->
  previousFrequencyData.push freqByteData

  if previousFrequencyData.length > 25
    previousFrequencyData.splice 0, 1

drawPastFrequencyGraphs = (canvas) ->
  length = previousFrequencyData.length
  ctx = canvas.getContext "2d"
  reach = canvas.width / 83.33

  startLength = if length == 0 then 0 else length - 1
  for i in [startLength..0]
    subLength = previousFrequencyData[i].length
    ctx.beginPath()
    ctx.moveTo 0, canvas.height
    for j in [1...subLength - 1]
      ctx.lineTo j * (canvas.width / 2.4) / subLength * reach, canvas.height - previousFrequencyData[i][j]
    ctx.lineTo (subLength - 1) * (canvas.width / 2.4) / subLength * reach, canvas.height
    ctx.lineWidth = 2
    ctx.strokeStyle = "#000"
    ctx.fillStyle = colors[i % 15]
    ctx.stroke()
    ctx.fill()

    ctx.beginPath()
    ctx.moveTo (subLength / 2) * (canvas.width / 2.4) / subLength * reach, 0
    for j in [subLength / 2 + 1...0]
      ctx.lineTo j * (canvas.width / 2.4) / subLength * reach, previousFrequencyData[i][j]
    ctx.lineTo 0, 0
    ctx.lineWidth = 2
    ctx.strokeStyle = "#000"
    ctx.fillStyle = colors[i % 15]
    ctx.stroke()
    ctx.fill()

    reach -= 0.2

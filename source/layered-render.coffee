globals = exports ? this

globals.layered_render = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  ctx.clearRect 0, 0, 500, 500

  drawPastFrequencyGraphs canvas

globals.updatePreviousFrequencyData = ->
  previous_frequency_data.push freqByteData

  if previous_frequency_data.length > 25
    previous_frequency_data.splice 0, 1

drawPastFrequencyGraphs = (canvas) ->
  length = previous_frequency_data.length
  ctx = canvas.getContext "2d"
  reach = 6

  startLength = if length == 0 then 0 else length - 1
  for i in [startLength..0]
    subLength = previous_frequency_data[i].length
    ctx.beginPath()
    for j in [0...subLength]
      if j == 0
        ctx.moveTo j * 1200 / subLength * reach, 500
      else if j == subLength - 1
        ctx.lineTo j * 1200 / subLength * reach, 500
      else
        ctx.lineTo j * 1200 / subLength * reach, 500 - previous_frequency_data[i][j]
    ctx.lineWidth = 2
    ctx.strokeStyle = "#000"
    ctx.fillStyle = colors[i % 15]
    ctx.stroke()
    ctx.fill()

    ctx.beginPath()
    for j in [subLength / 2..0]
      if j == subLength / 2
        ctx.moveTo j * 1200 / subLength * reach, 0
      else if j == 0
        ctx.lineTo j * 1200 / subLength * reach, 0
      else
        ctx.lineTo j * 1200 / subLength * reach, previous_frequency_data[i][j]
    ctx.lineWidth = 2
    ctx.strokeStyle = "#000"
    ctx.fillStyle = colors[i % 15]
    ctx.stroke()
    ctx.fill()

    reach -= 0.2

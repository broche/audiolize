globals = exports ? this

x = 0
highestPoints = []

globals.audiolize.renderers.equalizer =
  render: (canvas, data) ->
    ctx = canvas.getContext "2d"
    x = 0
    length = 100
    drawGraph canvas, data, i, length for i in [50...150]
    x = 0
    drawHighestPoints canvas, i, length for i in [0...100]

drawGraph = (canvas, data, i, length) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  grd = ctx.createLinearGradient 0, 0, 0, canvas.height
  grd.addColorStop 0, "#FF6840"
  grd.addColorStop 0.6, "#FFFA73"
  grd.addColorStop 1, "#35D59D"
  ctx.fillStyle = grd
  ctx.strokeStyle = "black"
  ctx.lineWidth = 0.4
  ctx.rect x, canvas.height, canvas.width / length, -data.frequency[i] * 1.5
  ctx.fill()
  ctx.stroke()
  x += canvas.width / length
  updateHighestPoints i - 50, data.frequency[i] * 1.5

updateHighestPoints = (index, value) ->
  if !highestPoints[index]? then highestPoints[index] = {value: 0}
  if highestPoints[index].value < value
    highestPoints[index] = {value: value}
  else
    highestPoints[index].value--


drawHighestPoints = (canvas, i, length) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  grd = ctx.createLinearGradient 0, 0, 0, canvas.height
  grd.addColorStop 0, "#FF6840"
  grd.addColorStop 0.6, "#FFFA73"
  grd.addColorStop 1, "#35D59D"
  ctx.fillStyle = grd
  ctx.strokeStyle = "black"
  ctx.lineWidth = 0
  ctx.rect x, canvas.height - highestPoints[i].value, canvas.width / length, 2
  ctx.fill()
  x += canvas.width / length


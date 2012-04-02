globals = exports ? this


globals.audiolize.renderers.stereo =
  render: (canvas, data) ->
    ctx = canvas.getContext "2d"
    drawBox canvas
    drawSpeakers canvas, getLowAvg data.frequency, getHighAvg data.time

getLowAvg = (data) ->
  sum = 0
  for i in [0...75]
    sum += data[i]
  avg = sum / 75

getHighAvg = (data) ->
  sum = 0
  for i in [75...150]
    sum += data[i] 
  avg = sum / 75

drawBox = (canvas) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  grd = ctx.createLinearGradient 230, 0, 370, 200
  grd.addColorStop 0, "#8ED6FF"
  grd.addColorStop 1, "#004CB3"
  ctx.fillStyle = grd
  ctx.strokeStyle = "black"
  ctx.lineWidth = 4
  ctx.rect (canvas.width / 2) - (200 / 2), (canvas.height / 2) - (350 / 2), 200, 350
  ctx.fill()
  ctx.stroke()

drawSpeakers = (canvas, low, high) ->
  if low < 100 then low = 100
  if low > 125 then low = 125
  if high < 100 then high = 100
  if high > 125 then high = 125

  ctx = canvas.getContext "2d"
  center = (canvas.width / 2)
  y = (canvas.height / 2)
  ctx.beginPath()
  ctx.arc center, y - 75, low/2, 0, 2 * Math.PI, false
  ctx.fillStyle = "#8ED6FF"
  ctx.fill()
  ctx.lineWidth = 5
  ctx.strokeStyle = "black"
  ctx.stroke()

  ctx.beginPath()
  ctx.arc center, y + 75, low/2, 0, 2 * Math.PI, false
  ctx.fillStyle = "#8ED6FF"
  ctx.fill()
  ctx.lineWidth = 5
  ctx.strokeStyle = "black"
  ctx.stroke()


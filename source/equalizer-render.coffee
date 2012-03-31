globals = exports ? this

#position
x = 0

globals.equalizerRender = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  ctx.clearRect 0, 0, canvas.width, canvas.height
  x = 0
  length = 100
  drawGraph canvas, i, length for i in [50...150]

drawGraph = (canvas, i, length) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  grd = ctx.createLinearGradient(0, 0, 0, canvas.height);
  grd.addColorStop 0, "#FF6840"
  grd.addColorStop 0.6, "#FFFA73"
  grd.addColorStop 1, "#35D59D"
  ctx.fillStyle = grd
  ctx.strokeStyle = "black"
  ctx.lineWidth = 0.4
  ctx.rect x, canvas.height, canvas.width / length, -(freqByteData[i] * 1.5)
  ctx.fill()
  ctx.stroke()
  x += canvas.width / length
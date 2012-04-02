globals = exports ? this

LENGTH = 125

globals.audiolize.renderers.hills = 
  render: (canvas, data) ->
    drawFrequencyGraphs canvas, data.frequency

drawFrequencyGraphs = (canvas, frequency) ->
  ctx = canvas.getContext "2d"

  # Draw the bottom frequency graph and calculates the average frequency for
  # other visualizations.
  ctx.beginPath()
  ctx.moveTo 0, canvas.height
  for i in [25...150]
    ctx.lineTo (i - 25) * (canvas.width) / LENGTH, canvas.height - frequency[i]
  ctx.lineTo LENGTH * (canvas.width) / LENGTH, canvas.height
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"
  grd = ctx.createLinearGradient 0, canvas.height / 2, 0, canvas.height / 1.25
  grd.addColorStop 0, "#7573D9"  # light blue
  grd.addColorStop 1, "#0B0974"  # dark blue
  ctx.fillStyle = grd
  ctx.stroke()
  ctx.fill()

  # Draw the upper frequency graph.
  ctx.beginPath()
  ctx.moveTo LENGTH * (canvas.width) / LENGTH, 0
  for i in [150...25]
    ctx.lineTo (i - 25) * (canvas.width) / LENGTH, frequency[i]
  ctx.lineTo 0, 0
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"
  grd2 = ctx.createLinearGradient 0, 0, 0, canvas.height / 5
  grd2.addColorStop 0, "#A60000"
  grd2.addColorStop 1, "#FF7373"
  ctx.fillStyle = grd2

  ctx.stroke()
  ctx.fill()

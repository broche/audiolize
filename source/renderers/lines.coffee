globals = exports ? this
  
averages = []
YSCALE = 1.66
WSCALE = 30

globals.audiolize.renderers.lines =
  render: (canvas, data) ->
    drawLineGraphs canvas, getAverageOf data.frequency


drawLineGraphs = (canvas, freq) ->
  ctx = canvas.getContext "2d"

  # Array of average frequency data.
  averages.push freq

  # Only store the most recent (canvas.width / 2) frequency data averages.
  if averages.length > canvas.width / 2
    averages.splice 0, 1

  # Draw the left graph.
  ctx.beginPath()
  ctx.moveTo 0, (canvas.height / YSCALE) - averages[i] / 2
  for i in [1...averages.length - 1]
    ctx.lineTo i, (canvas.height / YSCALE) - averages[i] / 2
  ctx.lineTo averages.length - 1, (canvas.height / YSCALE) - averages[i] / 2
  ctx.lineWidth = freq / WSCALE
  ctx.strokeStyle = "red"
  ctx.stroke()

  # Draw the right graph.
  ctx.beginPath()
  count = 0
  ctx.moveTo canvas.width, (canvas.height / YSCALE) - averages[count] / 2
  for i in [canvas.width + 1..canvas.width / 2]
    ctx.lineTo i, (canvas.height / YSCALE) - averages[count] / 2
    count++
  ctx.lineWidth = freq / WSCALE
  ctx.strokeStyle = "blue"
  ctx.stroke()

getAverageOf = (data) ->
  sum = 0
  sum += data[i] for i in [25...200]
  sum / 300
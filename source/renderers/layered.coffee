globals = exports ? this

colors = ["#025167",
          "#216477",
          "#057D9F",
          "#39AECF",
          "#61B7CF"]

globals.audiolize.renderers.layered = 
  render: (canvas, data) ->
    ctx = canvas.getContext "2d"
    scale = canvas.width / 83.33
    colorIndex = 0
    for i in [25..0]
      if i % 5 is 0 then colorIndex++
      drawBottomLayer canvas, data, i, scale, colorIndex
      drawTopLayer canvas, data, i, scale, colorIndex
      scale -= 0.2

drawBottomLayer = (canvas, data, i, scale, cIndex) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  ctx.moveTo 0, canvas.height
  for j in [50...150]
    ctx.lineTo (j - 50) * (canvas.width / 2.4) / 100 * scale, canvas.height - data.frequency[j]
  ctx.lineTo (data.frequency.length - 1) * (canvas.width / 2.4) / 100 * scale, canvas.height
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"
  ctx.fillStyle = colors[cIndex]
  ctx.stroke()
  ctx.fill()

drawTopLayer = (canvas, data, i, scale, cIndex) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  ctx.moveTo (data.frequency.length / 2) * (canvas.width / 2.4) / 100 * scale, 0
  for j in [150...50]
    ctx.lineTo (j - 50) * (canvas.width / 2.4) / 100 * scale, data.frequency[j]
  ctx.lineTo 0, 0
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"
  ctx.fillStyle = colors[cIndex]
  ctx.stroke()
  ctx.fill()
globals = exports ? this

globals.mainRender = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  ctx.clearRect 0, 0, 500, 500

  # Check to see if the checkbox assoociated with the corresponding visual is
  # checked. If it is, it renders the visual.
  if $("#background").attr "checked" then drawSpiral canvas, freq
  if $("#freq_graphs").attr "checked" then drawFrequencyGraphs canvas, freqByteData.length
  if $("#circles").attr "checked" then drawCircles canvas, freq
  if $("#bar_graphs").attr "checked" then drawLineGraphs canvas, freq

drawFrequencyGraphs = (canvas, length) ->
  ctx = canvas.getContext "2d"

  # Draw the bottom frequency graph and calculates the average frequency for
  # other visualizations.
  ctx.beginPath()
  for i in [0...length]
    if i == 0
      ctx.moveTo i * 1200 / length, 500
    else if i == length - 1
      ctx.lineTo i * 1200 / length, 500
    else
      ctx.lineTo i * 1200 / length, 500 - freqByteData[i]
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"

  grd = ctx.createLinearGradient 0, 250, 0, 400
  grd.addColorStop 0, "#7573D9"  # light blue
  grd.addColorStop 1, "#0B0974"  # dark blue
  ctx.fillStyle = grd
  ctx.stroke()
  ctx.fill()

  # Draw the upper frequency graph.
  ctx.beginPath()
  for i in [length / 2..0]
    if i == length / 2
      ctx.moveTo i * 1200 / length, 0
    else if i == 0
      ctx.lineTo i * 1200 / length, 0
    else
      ctx.lineTo i * 1200 / length, freqByteData[i]
  ctx.lineWidth = 2
  ctx.strokeStyle = "#000"
  grd2 = ctx.createLinearGradient 0, 0, 0, 100
  grd2.addColorStop 0, "#A60000"
  grd2.addColorStop 1, "#FF7373"
  ctx.fillStyle = grd2

  ctx.stroke()
  ctx.fill()

drawSpiral = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  ctx.beginPath()
  for i in [0...720]
    angle = 0.5 * i
    x = (1 + angle) * Math.cos angle
    y = (1 + angle) + Math.sin angle
    ctx.lineTo x + 250, y + 250
  ctx.strokeStyle = "black"
  ctx.lineWidth = freq / 100
  ctx.stroke()

drawCircles = (canvas, freq) ->
  # This is used to scale the trailing circles.
  dividedBy = 15
  colorID = 0

  # Only hold a maximum of 25 items in the list.
  while mousePositions.length > 25
    mousePositions.splice 0, 1
  for i in [0...mousePositions.length]
    ctx = canvas.getContext "2d"
    ctx.beginPath()
    size = freq / dividedBy
    if circles
      ctx.arc mousePositions[i][0], mousePositions[i][1], freq / dividedBy, 0, 2 * Math.PI, false
    else
      ctx.rect mousePositions[i][0] - size / 2, mousePositions[i][1] - size / 2, freq / dividedBy * 2, freq / dividedBy * 2
    ctx.fillStyle = colors[colorID % 10]
    ctx.fill()
    ctx.lineWidth = 2
    ctx.strokeStyle = "black"
    ctx.stroke()
    if i % 2 == 0 and dividedBy > 1
      dividedBy--
    colorID++

drawLineGraphs = (canvas, freq) ->
  ctx = canvas.getContext "2d"

  # Array of average frequency data.
  averages.push freq

  # Only store the most recent 250 mousePositions.
  if averages.length > 250
    averages.splice 0, 1

  # Draw the left graph.
  ctx.beginPath()
  for i in [0...averages.length]
    if i == 0
      ctx.moveTo 0, 300 - averages[i] / 2
    else if i == averages.length - 1
      ctx.lineTo i, 300 - averages[i] / 2
    else
      ctx.lineTo i, 300 - averages[i] / 2
  ctx.lineWidth = freq / 30
  ctx.strokeStyle = "red"
  ctx.stroke()

  # Draw the right graph.
  ctx.beginPath()
  count = 0
  for i in [500..250]
    if i == 500
      ctx.moveTo i, 300 - averages[count] / 2
    else
      ctx.lineTo i, 300 - averages[count] / 2
    count++
  ctx.lineWidth = freq / 30
  ctx.strokeStyle = "blue"
  ctx.stroke()
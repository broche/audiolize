globals = exports ? this
  
mousePositions = []
colors = ["#025167",
          "#216477",
          "#057D9F",
          "#39AECF",
          "#61B7CF"]

globals.audiolize.renderers.circles =
  render: (canvas, data) ->
    ctx = canvas.getContext "2d"
    drawTrailingCircles canvas, getAverageOf data.frequency

  addHandler: (canvasId) ->
    document.getElementById(canvasId).addEventListener 'mousemove', @getPosition, false

  removeHandler: (canvasId) ->
    document.getElementById(canvasId).removeEventListener 'mousemove', @getPosition, false

  getPosition: (e) ->
    # Only hold a maximum of 25 items in the list.
    if mousePositions.length >= 25 then mousePositions.splice 0, 1
    mousePositions.push [e.offsetX, e.offsetY]

drawTrailingCircles = (canvas, freq) ->
  ctx = canvas.getContext "2d"
  # This is used to scale the trailing circles.
  dividedBy = 15
  colorID = 0
  for i in [0...mousePositions.length]
    drawCircle ctx, mousePositions[i][0], mousePositions[i][1], freq / dividedBy, colors[colorID]
    if i % 2 == 0 and dividedBy > 1
      dividedBy--
    if i % 5 is 0 then colorID++

drawCircle = (ctx, x, y, radius, color) ->
  ctx.beginPath()
  ctx.arc x, y, radius, 0, 2 * Math.PI, false
  ctx.fillStyle = color
  ctx.fill()
  ctx.lineWidth = 2
  ctx.strokeStyle = "black"
  ctx.stroke()

getAverageOf = (data) ->
  sum = 0
  sum += data[i] for i in [25...200]
  sum / 300


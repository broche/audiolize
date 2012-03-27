#Producer Consumer Visualization

canvas = ctx = null
colors = ["#E1004C", "#FF7A00", "#620CAC", "#35D699", "#FFEC73"]
sound_files = ["sounds/0.ogg", "sounds/1.ogg", "sounds/2.ogg", "sounds/3.ogg", "sounds/4.ogg", "sounds/5.ogg", "sounds/6.ogg", "sounds/7.ogg", "sounds/8.ogg"]
context = null
audioSteps = []

$ ->
	init()

init = ->
	context = new webkitAudioContext(), sound_files, audioSteps = []
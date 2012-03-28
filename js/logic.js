//Canvas Variables
var visual_canvas;

//Audio Variables
var audioContext;
var analyser;
var source;
var freqByteData;
var timeByteData;
var averages = [];
var audioBuffer;

//Holds current mouse position 
var pos_x = 250;
var pos_y = 250;

//Determines if the user has already loaded
// at least one audio source
var already = false;

//Stores 25 most recent moust positions
var mouse_positions = [];
var colors = ["#1F6CA3", "#1F6CA3", "#1F6CA3", "#6397BB", "#6397BB", "#6397BB",
		 "#5DB8F8", "#5DB8F8", "#5DB8F8", "#87CBFC", "#87CBFC", "#87CBFC",
		 "#A7D9FC", "#A7D9FC", "#A7D9FC"];

var mouse_down = false;

//Used to determine if a song change has occured
// during a the step loop so it will stop looping 
// and load the song chosen
var song_change = false;

//Flag for drawing squares or circles
var circles = true;


//Standard way to do animation in javascript
// none of that setInterval B.S.
window.requestAnimFrame = (function (callback) {
	return window.requestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		window.mozRequestAnimationFrame ||
		window.oRequestAnimationFrame ||
		window.msRequestAnimationFrame ||
		function (callback) {
			window.setTimeout(callback, 5000 / 60);
		};
})();

//This function will set up all of the events
window.onload = function () {

	//Initialize the canvas variables
	visual_canvas = $("#music")[0];
	var ctx = visual_canvas.getContext("2d");

	//Display prompt
	ctx.font = "15pt Century Gothic";
	ctx.fillText("choose a song below...", 140, 250);

	initialize_events();

	//Create Web Audio API Context which is used to
	// create nodes, buffers, ect..
	audioContext = new window.webkitAudioContext();

};
function initialize_events() {
	var ctx = visual_canvas.getContext("2d");
	//Set up event when the mouse moves
	$("#music").mousemove(function (e) {
		//get mouse position
		pos_x = e.pageX - this.offsetLeft;
		pos_y = e.pageY - this.offsetTop;
		mouse_positions.push([pos_x, pos_y]);
	});
	$("#music").mousedown(function (e) {
		mouse_down = true;
		circles = !circles;
	});
	$("#music").mouseup(function (e) {
		mouse_down = false;
	});
	$("#song_select").children().click(function () {
		var song_url;
		if (!already) {
			ctx.clearRect(0, 0, 500, 500);
			ctx.font = "15pt Century Gothic";
			ctx.fillStyle = "red";
			ctx.fillText("loading song...", 175, 250);
			already = true;
			$("#song_id").html(this.alt);
			song_url = "sounds/" + this.id + ".ogg";
			loadAudio(song_url);
		} else {
			source.buffer = audioBuffer;
			source.noteOff(0);
			song_change = true;
			$("#song_id").html(this.alt);
			song_url = "sounds/" + this.id + ".ogg";
			loadAudio(song_url);
		}
	});
	$("#song_select").children().mouseover(function () {
		if (!already) {
			$("#song_id").html(this.alt);
		}
	});
	$("#song_select").children().mouseleave(function () {
		if (!already) {
			$("#song_id").html("song info");
		}
	});
}
function loadAudio(url) {
	//Create a buffer for the audio
	source = audioContext.createBufferSource();
	//Create an analyzer for the audio
	analyser = audioContext.createAnalyser();
	analyser.fftSize = 1024;

	//Connect the bufferSource to the analyzer
	source.connect(analyser);

	//Then connect the analyzer to the speakers
	analyser.connect(audioContext.destination);

	//Load the song chosen
	loadAudioBuffer(url);
}
function loadAudioBuffer(url) {

	// Load asynchronously (AJAX-y)
	var request = new XMLHttpRequest();
	request.open("GET", url, true);
	request.responseType = "arraybuffer";

	request.onload = function () {
		//Create a buffer for the audio that was loaded in
		audioBuffer = audioContext.createBuffer(request.response, false);
		audio_loaded();
	};
	request.send();
}

function audio_loaded() {
	//Allow for animation, and clear the screen
	song_change = false;
	var ctx = visual_canvas.getContext("2d");
	ctx.clearRect(0, 0, 500, 500);

	//connect the audio buffer to the source buffer
	source.buffer = audioBuffer;
	source.loop = true;
	//Play the audio NOW!
	source.noteOn(0.0);

	//Initialize the two arrays that will store frequency
	// data and time data
	freqByteData = new Uint8Array(analyser.frequencyBinCount);
	timeByteData = new Uint8Array(analyser.frequencyBinCount);

	//Begin Visualizer
	step(visual_canvas, render);
}
function render(canvas, freq) {
	var ctx = canvas.getContext("2d");
	ctx.clearRect(0, 0, 500, 500);
	//This is checking to see if the checkbox associated
	// with the certain visual is checked, and if so, it will
	// render the visual.  Otherwise, it will not.
	if ($('#background').attr('checked')) {
		draw_spiral(canvas, freq);
	}
	if ($('#freq_graphs').attr('checked')) {
		draw_frequency_graphs(canvas, freqByteData.length);
	}
	if ($("#circles").attr("checked")) {
		draw_circles(canvas, freq);
	}
	if ($("#bar_graphs").attr("checked")) {
		draw_line_graphs(canvas, freq);
	}
}

function step(canvas, render_callback) {
	update_analyser_data();
	render_callback(canvas, get_average_frequency());
	//If the user has clicked on any song during the
	// visualization, this flag is set so that a loading
	// message is draw on the screen, and animation loop 
	// will stop and start agasin once the song is loaded.
	if (song_change) {
		var ctx = canvas.getContext("2d");
		ctx.clearRect(0, 0, 500, 500);
		ctx.font = "15pt Century Gothic";
		ctx.fillStyle = "red";
		ctx.fillText("loading song...", 175, 250);
	} else {
		requestAnimFrame(function () {
			step(canvas, render_callback);
		});
	}
}
function update_analyser_data() {
	//Obtain the most recent time and frequency data;
	analyser.smoothingTimeConstant = 0.1;
	analyser.getByteFrequencyData(freqByteData);
	analyser.getByteTimeDomainData(timeByteData);
}
function get_average_frequency() {
	var length = freqByteData.length, sum = 0, j;
	for (j = 0; j < length; ++j) {
		sum += freqByteData[j];
	}
	return sum / length;
}
function draw_frequency_graphs(canvas, length) {
	var ctx = canvas.getContext("2d"), j, grd, grd2;
	//This draws the Bottom Frequency graph and calculates
	// the average frequency used for other visualizations
	ctx.beginPath();
	for (j = 0; j < length; ++j) {
		if (j === 0) {
			ctx.moveTo(j * (1200 / length), 500);
		} else if (j === length - 1) {
			ctx.lineTo(j * (1200 / length), 500);
		} else {
			ctx.lineTo(j * (1200 / length), 500 - freqByteData[j]);
		}
	}
	ctx.lineWidth = 2;
	ctx.strokeStyle = "#000";

	grd = ctx.createLinearGradient(0, 250, 0, 400);
	grd.addColorStop(0, "#7573D9"); // light blue
	grd.addColorStop(1, "#0B0974"); // dark blue
	ctx.fillStyle = grd;
	ctx.stroke();
	ctx.fill();

	//This is drawing the upper frequency graph
	ctx.beginPath();
	for (j = length - length / 2; j >= 0; --j) {
		if (j === length - length / 2) {
			ctx.moveTo(j * (1200 / length), 0);
		} else if (j === 0) {
			ctx.lineTo(j * (1200 / length), 0);
		} else {
			ctx.lineTo(j * (1200 / length), freqByteData[j]);
		}
	}
	ctx.lineWidth = 2;
	ctx.strokeStyle = "#000";
	grd2 = ctx.createLinearGradient(0, 0, 0, 100);
	grd2.addColorStop(0, "#A60000"); // light blue
	grd2.addColorStop(1, "#FF7373"); // dark blue
	ctx.fillStyle = grd2;

	ctx.stroke();
	ctx.fill();
}

function draw_spiral(canvas, freq) {
	var ctx = canvas.getContext("2d"), x, y, i, angle;
	ctx.beginPath();
	for (i = 0; i < 720; i++) {
		angle = 0.5 * i;
		x = (1 + angle) * Math.cos(angle);
		y = (1 + angle) * Math.sin(angle);
		ctx.lineTo(x + 250, y + 250);
	}
	ctx.strokeStyle = "black";
	ctx.lineWidth = freq / 100;
	ctx.stroke();
}
function draw_circles(canvas, freq) {
	var ctx = canvas.getContext("2d"), divided_by, color_id, i, size, count;
	//This is drawing the circles and the trailing circles
	divided_by = 15;
	color_id = 0;

	//Only hold a maximum of 25 items in the list
	while (mouse_positions.length > 25) {
		mouse_positions.splice(0, 1);
	}
	for (i = 0; i < mouse_positions.length; i++) {
		ctx.beginPath();
		size = freq / divided_by;
		if (circles) {
			ctx.arc(mouse_positions[i][0], mouse_positions[i][1], freq / divided_by, 0, 2 * Math.PI, false);
		} else {
			ctx.rect(mouse_positions[i][0] - (size / 2), mouse_positions[i][1] - (size / 2), (freq / divided_by) * 2, (freq / divided_by) * 2);
		}
		ctx.fillStyle = colors[color_id % 10];
		ctx.fill();
		ctx.lineWidth = 2;
		ctx.strokeStyle = "black";
		ctx.stroke();
		if (i % 2 === 0 && divided_by > 1) {
			divided_by--;
		}
		color_id++;
	}
}
function draw_line_graphs(canvas, freq) {
	var ctx = canvas.getContext("2d"), i, count;
	//Array of average frequency data
	averages.push(freq);

	//Only store the most recent 250 mouse_positions
	if (averages.length > 250) {
		averages.splice(0, 1);
	}

	//This is the left graph
	ctx.beginPath();
	for (i = 0; i < averages.length; i++) {
		if (i === 0) {
			ctx.moveTo(0, 300 - (averages[i] / 2));
		} else if (i === averages.length - 1) {
			ctx.lineTo(i, 300 - (averages[i] / 2));
		} else {
			ctx.lineTo(i, 300 - (averages[i] / 2));
		}
	}
	ctx.lineWidth = freq / 30;
	ctx.strokeStyle = "red";
	ctx.stroke();

	//This is the right graph
	ctx.beginPath();
	count = 0;
	for (i = 500; i >= 250; i--) {
		if (i === 500) {
			ctx.moveTo(i, 300 - (averages[count] / 2));
		} else {
			ctx.lineTo(i, 300 - (averages[count] / 2));
		}
		count++;
	}
	ctx.lineWidth = freq / 30;
	ctx.strokeStyle = "blue";
	ctx.stroke();
}
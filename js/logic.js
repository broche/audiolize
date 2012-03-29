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

//Array of the previous 25 frequency data arrays
var previous_frequency_data = [];

//Standard way to do animation in javascript
// none of that setInterval B.S.
window.requestAnimFrame = (function () {
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
	$("#music").mousedown(function () {
		mouse_down = true;
		circles = !circles;
	});
	$("#music").mouseup(function () {
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
	step(visual_canvas, main_render);
	//step(visual_canvas, layered_render);
}

function step(canvas, render_callback) {
	update_analyser_data();
	update_previous_frequency_data();
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
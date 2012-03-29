function layered_render(canvas, freq) {
	var ctx = canvas.getContext("2d");
	ctx.clearRect(0, 0, 500, 500);
	//This is checking to see if the checkbox associated
	// with the certain visual is checked, and if so, it will
	// render the visual.  Otherwise, it will not.
	draw_past_frequency_graphs(canvas);
}
function update_previous_frequency_data() {

	//Add the newest frequency data to the end of the array
	previous_frequency_data.push(freqByteData);

	//Only store the most recent 25 freqByteData arrays
	if(previous_frequency_data.length > 25){
		previous_frequency_data.splice(0, 1);
	}
}

function draw_past_frequency_graphs(canvas) {
	var i, j, length = previous_frequency_data.length, sub_length,
	ctx = canvas.getContext("2d"), start_length, reach = 6;
	
	length === 0 ? start_length = 0 : start_length = length - 1; 
	for(i = start_length; i >= 0; i--){
		sub_length = previous_frequency_data[i].length;
		ctx.beginPath();
		for (j = 0; j < sub_length; ++j) {
			if (j === 0) {
				ctx.moveTo(j * ((1200 / sub_length) * reach), 500);
			} else if (j === sub_length - 1) {
				ctx.lineTo(j * ((1200 / sub_length) * reach), 500);
			} else {
				ctx.lineTo(j * ((1200 / sub_length) * reach), 500 - 
					previous_frequency_data[i][j]);
			}
		}
		ctx.lineWidth = 2;
		ctx.strokeStyle = "#000";
		ctx.fillStyle = colors[i % 15];
		ctx.stroke();
		ctx.fill();

		reach -= 0.2;
	}
}
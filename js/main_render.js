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
	var ctx = canvas.getContext("2d"), divided_by, color_id, i, size;
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
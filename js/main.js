// set default volume values for each track
var trackVolumes = {
			volume0: 1,
			volume1: 0,
			volume2: 0,
			volume3: 0,
			mute: false
		};

window.onload = function() {

	/* ------------------------------------------------

	STEP 2: Web Audio API

	------------------------------------------------ */
	var context = new webkitAudioContext(),	// webkit audio context for sound
		audioFiles = [ 	// tracks
			'sound/step0.ogg',
			'sound/step1.ogg',
			'sound/step2.ogg',
			'sound/step3.ogg '
		],
		audioSteps = []; // stores the 4 audio element objects


	/* ------------------------------------------------

	STEP 3: Loading the Sounds

	------------------------------------------------ */
	var bufferLoader = new BufferLoader(context, audioFiles, onAudioLoaded); 
	bufferLoader.load();



	/* ------------------------------------------------

	STEP 4: Play ‘em

	------------------------------------------------ */
	function onAudioLoaded(bufferList) {

		// start interval for drawing rings
		//createRings();
		//setInterval(createRings, 215);
		
		// loop through the buffer list and set up the sources
		for(var i = 0; i < bufferList.length; i++) {

			// create buffer source
			var bufferSource = context.createBufferSource();
			bufferSource.buffer = bufferList[i];
			bufferSource.looping = true;

			// create gain node
			var gainNode = context.createGainNode();
			bufferSource.connect(gainNode);
			gainNode.connect(context.destination);
			gainNode.gain.value = trackVolumes['volume' + i];
			

			// create audio element object
			var audioElem = {
				source: bufferSource,
				gainNode: gainNode
			}

			audioSteps.push(audioElem);
		}

		// start playing loops
		for(var j = 0; j < audioSteps.length; j++) {
			audioSteps[j].source.noteOn(0);
		}
	}

	/* ------------------------------------------------

	STEP 5: Kick Off the Animations

	------------------------------------------------ */
	var counter = 0;
	function createRings() {
		counter += 1;
		for(var i = 0; i < 4; i++){
			var vol = trackVolumes['volume' + i],
				perc = Math.max( 1, Math.round((1 - vol) * 10) - 2 );
			if(vol > 0) {
				if(vol == 1){
					window.createRing(i);
				}
				else if(counter % perc == 0) {
					window.createRing(i);
				}
			}
		} 
	}

	/* ------------------------------------------------

	STEP 6: Controls

	------------------------------------------------ */
	var gui = new dat.GUI(),
		trackNames = [
			'Shaker',
			'Synth',
			'Drums',
			'Wobble'
		];
	
	// add 5 controls for each track
	for(var i = 0; i < 4; i++){
		gui.add(trackVolumes, 'volume' + i).min(0).max(1).step(0.1).name(trackNames[i]).onChange(function(newValue) {
			// get index of sound (0 - 4)
			var index = parseInt(this.property.replace('volume', ''), 10);
			// set new volume
			audioSteps[index].gainNode.gain.value = newValue;
		});
	}
	// add mute all button
	gui.add(trackVolumes, 'mute').name('Mute All').onChange(function(newValue) {
		if(!newValue) {
			for(var n = 0; n < 4; n++) {
				audioSteps[n].gainNode.gain.value = trackVolumes['volume' + n];
			}
		}else {
			for(var n = 0; n < 4; n++) {
				audioSteps[n].gainNode.gain.value = 0;
			}
		}
	});
}
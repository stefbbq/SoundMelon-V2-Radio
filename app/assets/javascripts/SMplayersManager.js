//Players Manager
var ytPlayer, scWidget, bufferInterval, bufferLength;

var SMplayersManager = function($scAppId) {
	var scAppId = $scAppId;
	var playerHeight = '320';
	var playerWidth = '564';

	function loadInterval(song) {
		if(song.upload_source === "soundcloud") {
			scWidget.load().play();
		}
		else if(song.upload_source === "youtube") {
			ytPlayer.stopVideo().playVideo();
		}
		var message = {
			severity: "Standby",
			message: "Servers are slow today, please wait!"
		}
		FlashManager.showMessage(message);
	}
	
	function initSCPlayer() {
		//Load the SC player the first time a SC file is streamed in session
		SC.initialize({
			//client_id: '#{ENV["SOUNDCLOUD_APP_ID"]}'
			client_id: scAppId
		});
		scPlayerReady = true;
		runInitSC = true;
	}

	function loadSCSong(song) {
		console.log('about to stream!');
		bufferInterval = setInterval(function() {loadInterval(song)}, 5000);
		SC.stream('/tracks/' + song['song_id'], {
			preferFlash: false,
			onfinish: function() {
					console.log('finished this SC song...');
					clearInterval(scrubInterval);
					$('#play-pause .control-image').removeClass('play-image pause-image').addClass('loading-image ');
					$(".seek-scrub").addClass('disable');
					RadioManager.playNextSong();
			},
			onresume: function() {
				$('#play-pause .control-image').removeClass('loading-image ').addClass('pause-image');
			},
			onstop: function() {
				$('#play-pause .control-image').removeClass('loading-image ').addClass('play-image');
			},
			onpause: function() {
				$('#play-pause .control-image').removeClass('loading-image ').addClass('play-image');
			},
			onplay: function() {
				// alert('ready!');
				clearInterval(bufferInterval);
				$(".seek-scrub").removeClass('disable');
				$('#play-pause .control-image').removeClass('loading-image ').addClass('pause-image');
			},
			onready: function() {

				
			}
			}, function(sound) {
				scWidget = sound;
				playSCTrack();
			});
	}
	
	function playSCTrack() {
		console.log('should play now...');
		scWidget.setVolume(volume);
		scWidget.play();
		scrubInterval = setInterval(RadioManager.seekTracker, scrubDelay);
	}
	
	
	function setQuality(level) {
		ytPlayer.setPlaybackQuality(level);
	}
	
	function onYouTubeIframeAPIReady() {
		console.log('onto the YT');
		ytPlayer = new YT.Player('youtube', {
			playerVars: {
				'rel': 0,
				'html5': 1,
				'controls': 0,
				'showinfo': 0
			},
			height: playerHeight,
			width: playerWidth,
			events: { 
				'onReady': ytOnReady,
				'onPlaybackQualityChange': ytPlaybackQualityChange,
				'onStateChange': ytStateChange,
				'onError': ytError
			}
		});
		console.log(ytPlayer.b.b.events);
	}
	
	function ytOnReady() {
		ytPlayerReady = true;
		console.log('yt is now ready!');
		setQuality(ytQuality);
		console.log(event);
		RadioManager.executePlaylist();
	}
	
	function ytPlaybackQualityChange() {
		console.log(ytPlayer.getPlaybackQuality());
	}
	
	function ytStateChange() {
		console.log(event.data);
		var state = ytPlayer.getPlayerState();
		if(state === 0) {
			clearInterval(scrubInterval);
			$(".seek-scrub").addClass('disable');
			$('#play-pause .control-image').removeClass('play-image pause-image').addClass('loading-image ');
			RadioManager.playNextSong();
		}
		else if(state === 1) {
			clearInterval(bufferInterval);
			scrubInterval = setInterval(RadioManager.seekTracker, scrubDelay);
			$(".seek-scrub").removeClass('disable');
			$('#play-pause .control-image').removeClass('loading-image ').addClass('pause-image');
			if(ytPlayer.getPlaybackQuality !== ytQuality) {
				setQuality(ytQuality);
			}
		}
		else if(state === 2) {
			$('#play-pause .control-image').removeClass('loading-image ').addClass('play-image');
		}
		else if(state === 3) {
			$('#play-pause .control-image').removeClass('play-image pause-image').addClass('loading-image ');
		}
	}
	
	function ytError() {
		console.log(event);
		if(/100|101|150/.test(event.data)) {
			RadioManager.playNextSong();
		}
	}
	
	return {
		onYouTubeIframeAPIReady: onYouTubeIframeAPIReady,
		initSCPlayer: initSCPlayer,
		loadSCSong: loadSCSong,
		playSCTrack: playSCTrack,
		loadInterval: loadInterval
	}
}
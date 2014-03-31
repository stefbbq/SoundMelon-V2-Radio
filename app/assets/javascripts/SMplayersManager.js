//Players Manager
var ytPlayer, scWidget;

var SMplayersManager = function($scAppId) {
	var scAppId = $scAppId;
	var playerHeight = '320';
	var playerWidth = '564';
	
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
		SC.stream('/tracks/' + song['song_id'], {
			preferFlash: false,
			onfinish: function() {
					console.log('finished this SC song...');
					clearInterval(scrubInterval);
					playNextSong();
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
		if(ytPlayer.getPlayerState() === 0) {
			clearInterval(scrubInterval);
			playNextSong();
		}
		else if(ytPlayer.getPlayerState() === 1) {
			scrubInterval = setInterval(RadioManager.seekTracker, scrubDelay);
			if(ytPlayer.getPlaybackQuality !== ytQuality) {
				setQuality(ytQuality);
			}
		}
	}
	
	function ytError() {
		console.log(event);
		if(/100|101|150/.test(event.data)) {
			playNextSong();
		}
	}
	
	return {
		onYouTubeIframeAPIReady: onYouTubeIframeAPIReady,
		initSCPlayer: initSCPlayer,
		loadSCSong: loadSCSong,
		playSCTrack: playSCTrack
	}
}
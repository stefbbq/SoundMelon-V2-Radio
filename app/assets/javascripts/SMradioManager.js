//Radio Manager

var ytPlayerReady = false;
var scPlayerReady = false;
var runOnYTReady = false;
var runInitSC = false;
var newArtistProfile, scrubInterval;
var volume = 100;
var ytQuality = 'large';
var scrubDelay = 500;
var firstRun = true;

var SMradioManager = function(scAppId) {
	var playersManager, artistsManager, songs, songHistory, playedUpdate, currentSong, playLast, lastPlayed, lastStation, currentStation, seekVal, position, stillBuffering, checkTimeout;
	
	var songHistory = []; //full browser history of played songs
	var playedUpdate = []; //gets sent to the server as an update
	
	
	function enable() {
		playersManager = new SMplayersManager(scAppId);
		artistsManager = new SMartistsManager();
		$('#radio-controls #play-pause').click(playBehaviour);
		key('space', function() {
			$('#radio-controls #play-pause').trigger('click');
		});
		$('#radio-controls #next-song').click(nextBehaviour);
		key('right', function() {
			$('#radio-controls #next-song').trigger('click');
		});
		// $('#radio-controls #previous-song').click(prevBehaviour);
		$('#get-artist-info').click(getArtistInfo);
		$('#radio-stations a').click(setStation);
		$('#report-song').click(openReportForm);

		$('.volume-container #volume-slider').slider('value', volume);
		
		$('.volume-container #show-slider, .volume-controls').hover(function() {
			$('.volume-controls').toggle();
		});

		$('#seek-slider').simpleSlider({
			highlight: true
		});
		$('#seek-slider').simpleSlider('setValue', 0);
		$('#seek-slider').bind('slider:changed', function(event, data) {
			seekValue = data['value'];
			position = secToMinSec(currentSongTime(currentSong));
			$('#radio-controls .seek-scrub .seek-val span.current-time').text(position);
		});

		$('.media-seeker .slider').mouseup(function() {
			clearInterval(scrubInterval);
			console.log('initialize...');
			manualSeek(seekValue);
		});
		
		$('#radio-stations #user-meta').trigger('click');
	}
	
	//
	//behaviour
	function playBehaviour() {
		$(this).children('.control-image').removeClass('play-image pause-image').addClass('spinner ');
		if(currentSong) {
			playPause();
		}
		else{
			newSongsList();
		}
	}
	
	function nextBehaviour() {
		if(scWidget) scWidget.stop();
		if(!$(this).hasClass('disable')) {
			clearInterval(scrubInterval);
			$('#seek-slider').simpleSlider('setValue', 0);
			if(currentSong) {
				if(currentSong['upload_source'] === 'youtube') {
					ytPlayer.stopVideo();
				}
				else if(currentSong['upload_source'] === 'soundcloud') {
					scWidget.pause();
				}
				playNextSong();
			}
			$(this).addClass('disable');
		}
	}
	
	function prevBehaviour() {
		if(currentSong && songHistory.length > 0){
			playLast = true;
			$('#radio-controls #next-song').trigger('click');
		}
	}
	
	function getArtistInfo() {
		// console.log(this);
		artistsManager.setArtistInfo(this, currentSong);
	}
	
	function setStation() {
		lastStation = currentStation;
		if(lastStation !== this.id) {
			$('#' + lastStation).toggleClass('idle streaming');
			currentStation = this.id;
			$('#' + currentStation).toggleClass('idle streaming');
			if(currentSong) {
				if(currentSong['upload_source'] === 'youtube') {
					ytPlayer.stopVideo();
				}
				else if(currentSong['upload_source'] === 'soundcloud') {
					scWidget.pause();
				}
				newSongsList();
			}
		}
	}
	
	function openReportForm() {
		z = this.href.split(/song_id=|(?=&user_id)/);
		this.href = z[0] + 'song_id=' + z[z.length-1];
		reportBox = $('.report-box');
		if(!currentSong) {
			return false;
		}
		else {
			y = this.href.split('song_id=');
			this.href = y[0] + 'song_id=' + currentSong['song_id'] + y[1];
			console.log(this.href)
			return true;
		}
	}
	

	function newSongsList() {
		var radioStation = {station: currentStation, played_songs: playedUpdate, user_id: currentUserId};
		console.log(radioStation);
		$.ajax({
			url: '/request_playlist',
			data: radioStation,
			success: function(data) {
				if(data.length > 0) {
					songs = shuffleList(data);
					executePlaylist();
				} 
				else requestHistoryReset();
			}
		});
		playedUpdate = [];
	}

	function requestHistoryReset() {
		$.ajax({
			url: '/request_history_reset',
			data: {station: currentStation, user_id: currentUserId},
			success: function(data) {
				songs = shuffleList(data);
				console.log(songs);
				executePlaylist();
			}
		});
	}
	
	function executePlaylist() {
		console.log('trying to execute playlist');
		setTimeout(checkPlaying, 10000);
		if(!ytPlayerReady) {
			//Wait until players are ready
			if(!runOnYTReady) {
				console.log('initializing the players.');
				playersManager.onYouTubeIframeAPIReady();
				playersManager.initSCPlayer();
				
				runOnYTReady = true;
			}
		}
		else {
			//Once players are ready execute the playlist
			console.log('all ready and initialized!');

			if(songs.length > 0) {
				var firstSong = songs[0];
				var firstSource = firstSong['upload_source'];
				currentSong = firstSong;
				artistsManager.showArtistInfo(currentSong);
				// playPause();
				$(".change-song").addClass('enable-control');
				if(firstSource === 'youtube') {
					$('#soundcloud, .overlay, .overlay .song-link').hide();
					$('#youtube').css('display', 'block');
					bufferInterval = setInterval(function() {playersManager.loadInterval(currentSong)}, 5000);
					ytPlayer.loadVideoById({videoId: firstSong['song_id']});
					ytPlayer.setVolume(volume);
				}
				else if(firstSource === 'soundcloud') {
					playersManager.loadSCSong(currentSong);
					$('#youtube').hide();
					$('#soundcloud, .overlay, .overlay .song-link').show();
				}
				if(firstRun) {
					 $("#get-artist-info").trigger('click');
					 firstRun = false;
				}
				else {
					loadInArtistInfo();
				}
			}
		}
	}
	
	function playPause() {
		if(currentSong['upload_source'] === 'youtube') {
			var playerState = ytPlayer.getPlayerState();
			if(/[25]|-1/.test(playerState)){
				//Play video if it is paused (2), cued (5), or unstarted (-1)
				ytPlayer.setVolume(volume);
				ytPlayer.playVideo();
			}
			else if(/[13]/.test(playerState)) {
				//Pause video if already playing or buffering
				ytPlayer.pauseVideo();
			}
		}
		else if(currentSong['upload_source'] == 'soundcloud') {
			if(scWidget.paused) {
				scWidget.setVolume(volume);
				scWidget.play();
			}
			else {
				console.log('sc pausing...')
				scWidget.pause();
			}
		}
	}
	
	function playNextSong(){
		//Identify source of the next song and play it in the
		// appropriate player
		if(!playLast) {
			songHistory.push(songs.shift());
			playedUpdate.push(songHistory[songHistory.length - 1]['song_id'])
		}
		else {
			songs.unshift(songHistory.pop());
			playedUpdate.pop();
			playLast = false;
		}
		if(songs.length > 0) {
			var nextSong = songs[0];
			lastPlayed = currentSong;
			currentSong = nextSong;
			artistsManager.showArtistInfo(currentSong);
			
			console.log('hiding .player');
			if(nextSong['upload_source'] === 'youtube') {
				bufferInterval = setInterval(function() {playersManager.loadInterval(currentSong)}, 5000);
				ytPlayer.loadVideoById({videoId: currentSong['song_id']});
				ytPlayer.setVolume(volume);
				$('#soundcloud, .overlay, .overlay .song-link').hide();
				$('#youtube').show();
			}
			else if(nextSong['upload_source'] === 'soundcloud') {
				playersManager.loadSCSong(currentSong);
				$('#youtube').hide();
				$('#soundcloud, .overlay, .overlay .song-link').show();
			}
			calloutBox = $('.callout#show-artist-profile');
			if(calloutBox.hasClass('visible')) {
				newArtistProfile = true;
				$('#get-artist-info').click();
			}
			setTimeout(checkPlaying, 10000);
			loadInArtistInfo();
		}
		else {
			//Songs list is now empty
			newSongsList();
		}
	}

	function checkPlaying() {
		var showError;
		if(!currentSong) showErrrow = true;
		else if(currentSong['upload_source'] === 'youtube') {
			var status = ytPlayer.getPlayerState();
			if(/3|-1/.test(status)) {
				showError = true;
			}
		}
		else if(currentSong['upload_source'] === 'soundcloud') {
			console.log(scWidget.isBuffering);
			if(!scWidget || scWidget.isBuffering) {
				showError = true;
			}
		}

		if(showError) {
			var message;
			if(stillBuffering) {
				message = {
					severity: 'error', 
					message: 'There was a loading error, please reload the page.'
				};
			}
			else {
				message = {
					severity: 'warning', 
					message: 'Please wait while we get the content!'
				};
			}
			FlashManager.showMessage(message);
			stillBuffering = true;
			checkTimeout = setTimeout(checkPlaying, 10000);
		}
		else console.log('no load delays!');
		clearTimeout(checkTimeout);
		FlashManager.animateOut(0);
	}
	
	function seekTracker() {
		if(currentSong) {
			var newVal;
			if(currentSong['upload_source'] === 'youtube') {
				newVal = ytPlayer.getCurrentTime() / ytPlayer.getDuration();
			}
			else if(currentSong['upload_source'] === 'soundcloud') {
				newVal = scWidget.position / scWidget.durationEstimate;
			}
			// console.log(newVal);
			$('#seek-slider').simpleSlider('setValue', newVal);
		}
	}

	function loadInArtistInfo() {
		setTimeout(function() {
			$("#next-song").removeClass('disable');
			calloutBox = $('.callout#show-artist-profile');
			if(calloutBox.hasClass('visible')) {
				newArtistProfile = true;
				$('#get-artist-info').click();
			}
		}, 3000);
	}

	function manualSeek(seekTo) {
		console.log('executing...')
		if(currentSong) {
			if(currentSong['upload_source'] === 'youtube') {
				ytPlayer.seekTo( seekTo * ytPlayer.getDuration() );
				console.log(ytPlayer.getCurrentTime());
			}
			else if(currentSong['upload_source'] === 'soundcloud') {
				scWidget.setPosition( seekTo * scWidget.duration );
				console.log(scWidget.position);
			}
			scrubInterval = setInterval(seekTracker, scrubDelay);
		}
	}
	
	function getSongDuration(song) {
		if(song['upload_source'] === 'youtube') {
			return ytPlayer.getDuration();
		}
		else if(song['upload_source'] === 'soundcloud') {
			return scWidget.duration/1000;
		}
	}
	
	function currentSongTime(song) {
		if(song['upload_source'] === 'youtube') {
			return ytPlayer.getCurrentTime();
		}
		else if(song['upload_source'] === 'soundcloud') {
			return scWidget.position/1000;
		}
	}

	$('.volume-container #volume-slider').slider({
		orientation: 'vertical',
		range: 'min',
		change: function(event, ui) {
			volume = ui['value']
			if(currentSong) {
				if(currentSong['upload_source'] === 'youtube') {
					ytPlayer.setVolume(volume);
				}
				else if(currentSong['upload_source'] === 'soundcloud') {
					scWidget.setVolume(volume);
				}
			}
		}
	});
	

	return {
		enable: enable,
		seekTracker: seekTracker,
		executePlaylist: executePlaylist,
		playNextSong: playNextSong,
		
		//vars
		playersManager: playersManager
	}
}
//radio manager

var ytPlayerReady = false;
var scPlayerReady = false;
var runOnYTReady = false;
var runInitSC = false;
var newArtistProfile, CalloutManager, soundManager;
var scrubInterval;
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
		CalloutManager = new SMcalloutManager($("#callout-wrapper"));
		CalloutManager.enable();
		// FavoritesCallout = new SMcalloutItem($('#favorites-panel-button'), $(".callout-wrapper.favorites-panel"));

		//basic commands
		$('#radio-controls #play-pause').click(playBehaviour);
		$('#get-artist-info').click(getArtistInfo);
		$('#radio-stations a').click(setStation);
		$('#report-song').click(openReportForm);
		$('#radio-stations #user-meta').trigger('click');
		$("#add-to-favorites").click(addToFavorites);
		
		//keyboard bindings
		key('space', function() {
			$('#radio-controls #play-pause').trigger('click');
		});
		$('#radio-controls #next-song').click(nextBehaviour);
		key('right', function() {
			$('#radio-controls #next-song').trigger('click');
		});
		
		//volume controls
		$('.volume-container #volume-slider').slider('value', volume);
		$('.volume-container').hover(function() { $('.volume-controls').toggle(); });

		//volume controls
		$('#seek-slider').simpleSlider({ highlight: true });
		$('#seek-slider').simpleSlider('setValue', 0);
		$('#seek-slider').bind('slider:changed', function(event, data) {
			seekValue = data['value'];
			position = secToMinSec(currentSongTime(currentSong));
			$('#radio-controls .seek-scrub .seek-val span.current-time').text(position);
		});

		//time seek controls
		$('.media-seeker .slider').find('.track, .highlight-track').click(function() {
			scrubInterval.stop();
			manualSeek(seekValue);
			if(getPlayerState() === 1) scrubInterval.start();
		});
		$('.media-seeker .dragger').mousedown(function() {
			scrubInterval.stop();
		}).mouseup(function() {
			manualSeek(seekValue);
			if(getPlayerState() === 1) scrubInterval.start();
		});
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
		if(soundManager) {
			console.log("STOP ALL");
			soundManager.stopAll();
			// scWidget.stop();
		}
		if(!$(this).hasClass('disable')) {
			scrubInterval.stop();
			$('#seek-slider').simpleSlider('setValue', 0);
			if(currentSong) {
				if(currentSong['upload_source'] === 'youtube') {
					ytPlayer.stopVideo();
				}
				else if(currentSong['upload_source'] === 'soundcloud') {
					// scWidget.pause();
					soundManager.stopAll();
					scWidget.destruct();
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
		artistsManager.setArtistInfo(currentSong);
	}
	
	function setStation() {
		lastStation = currentStation;
		// var this = this ? this : item;
		var newStation = $(this).attr('data-station-id');
		// console.log(this.id);
		if(lastStation !== newStation || newStation === "favorites") {
			$('#' + lastStation).toggleClass('idle streaming').closest('.list-item').removeClass('current');
			currentStation = newStation;
			$('#' + currentStation).toggleClass('idle streaming').closest('.list-item').addClass('current');
			$("#station-panel-button").find('.active-label').html($(this).attr('data-station-label'));
			if(currentSong) {
				if(currentSong['upload_source'] === 'youtube') {
					ytPlayer.stopVideo();
				}
				else if(currentSong['upload_source'] === 'soundcloud') {
					scWidget.destruct();
					soundManager.stopAll();
				}
				var args = {favStartVal: $(this).closest('.list-item').attr('data-position')}
				newSongsList(args);
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
	

	function newSongsList(args) {
		var radioStation;
		if(currentStation === 'favorites' && args) {
			var start = args.favStartVal;
			var allFavs = $("#favorites-panel .song-item");
			var selected = allFavs.slice(start, allFavs.length);
			selected.removeClass('current');
			selected.first().addClass('current');
			var songList = [];
			for(i=0; i < selected.length; i++) {
				songList.push($(selected[i]).attr('data-song-id'));
			}
			radioStation = {station: currentStation, song_list: songList, user_id: currentUserId};
		}
		else if(currentStation === 'favorites') {
			$('.stations #user-meta').trigger('click');
		}
		else {
			radioStation = {station: currentStation, played_songs: playedUpdate, user_id: currentUserId};	
		}
		
		console.log(radioStation);
		$.ajax({
			url: '/request_playlist',
			data: radioStation,
			success: function(data) {
				if(data.length > 0) {
					songs = currentStation === "favorites" ? data : shuffleList(data);
					console.log(songs);
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
				$(".next-song").addClass('enable-control');
				$(".volume").addClass('enable-control');
				
				if(firstSource === 'youtube') {
					$('#soundcloud, .overlay, .overlay .song-link').hide();
					$('#youtube').css('display', 'block');
					bufferInterval = setInterval(function() {playersManager.loadInterval(currentSong)}, 5000);
					ytFirstPlayForSong = true;
					ytPlayer.loadVideoById({videoId: firstSong['song_id']});
					ytPlayer.setVolume(volume);
				}
				else if(firstSource === 'soundcloud') {
					playersManager.loadSCSong(currentSong);
					$('#youtube').hide();
					$('#soundcloud, .overlay, .overlay .song-link').show();
				}
				updateFavoritesPlaylist();
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
				ytFirstPlayForSong = true;
				ytPlayer.playVideo();
			}
			else if(/[13]/.test(playerState)) {
				//Pause video if already playing or buffering
				ytPlayer.pauseVideo();
			}
		}
		else if(currentSong['upload_source'] == 'soundcloud') {
			// soundManager.pauseAll();
			if(scWidget.paused) {
				scWidget.setVolume(volume);
				scWidget.play();
			}
			else {
				console.log('sc pausing...')
				soundManager.pauseAll();
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
				ytFirstPlayForSong = true;
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
				getArtistInfo();
			}
			setTimeout(checkPlaying, 10000);
			loadInArtistInfo();
			$("#favorites-panel .song-item").removeClass('current');
			updateFavoritesPlaylist();
		}
		else {
			//Songs list is now empty
			newSongsList();
		}
	}

	function getPlayerState() {
		//-1: unstarted, 1: playing, 2: paused
		if(!currentSong) return -1;
		else {
			if(currentSong['upload_source'] === 'youtube') {
				var state = ytPlayer.getPlayerState();
				if(/1|2/.test(state)) return state;
			}
			else if(currentSong['upload_source'] === 'soundcloud') {
				var state = scWidget.paused ? 2 : 1;
				return state;
			}
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
	scrubInterval = SMinterval(seekTracker, scrubDelay);

	function loadInArtistInfo() {
		setTimeout(function() {
			$("#next-song").removeClass('disable');
			calloutBox = $('.callout#show-artist-profile');
			if(calloutBox.hasClass('visible')) {
				newArtistProfile = true;
				getArtistInfo();
			}
		}, 1000);
	}

	function addToFavorites() {
		var linkBox = $(this).closest('.favorites-link');
		// linkBox.toggleClass('filled');
		// if(currentSong) {
		// 	if(currentSong['favorite'] === "false") currentSong['favorite'] = "true";
		// 	else currentSong['favorite'] = "false";
		// }
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
			// scrubInterval.start();
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

	function setFavoriteState(val) {
		currentSong['favorite'] = val;
	}

	function updateFavoritesPlaylist() {
		$("#favorites-panel .song-item").removeClass('current');
		if(currentStation === 'favorites') {
			$("#favorites-panel .song-item[data-song-id='"+currentSong['song_id']+"']").addClass('current');
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
		getPlayerState: getPlayerState,
		setFavoriteState: setFavoriteState,
		setStation: setStation,
		updateFavoritesPlaylist: updateFavoritesPlaylist,
		playPause: playPause,
		playBehaviour: playBehaviour,
		
		//vars
		playersManager: playersManager,
		currentSong: function() {
			return currentSong;
		}
	}
}
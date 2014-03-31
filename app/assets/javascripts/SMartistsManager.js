//Artists Manager

var SMartistsManager = function() {
	
	function setArtistInfo($link, $currentSong) {
		var currentSong = $currentSong;
		console.log($link);
		var z = $link.href.split('song_id=');
		console.log(z);
		$link.href = z[0] + 'song_id=';
		if(!currentSong) {
			return false;
		}
		else {
			var calloutBox = $('.callout#show-artist-profile');
			if(( calloutBox.css('display') === 'block' ) && (!newArtistProfile)) {
				calloutBox.find('.container').remove();
				calloutBox.hide();
				$($link).removeClass('current-visit');
				return false;
			}
			else {
				newArtistProfile = false;
				console.log($link.href);
				$link.href = $link.href + currentSong['song_id'];
				console.log($link.href);
				$($link).addClass('current-visit');
			}
		}
	}
	
	function showArtistInfo(song) {
		var songTitle = $('#radio-controls .primary .currently-playing span.song-title');
		var artistName = $('#radio-controls .primary .currently-playing span.artist');
		var songDuration = $('#radio-controls .seek-scrub .seek-val span.duration');
		songTitle.text(song['song_title']);
		artistName.text(song['artist_name']);
		var duration = song['duration'].split(/^0/);
		duration = duration[duration.length - 1];
		songDuration.text(duration);
	}
	
	return {
		setArtistInfo: setArtistInfo,
		showArtistInfo: showArtistInfo
	}
}
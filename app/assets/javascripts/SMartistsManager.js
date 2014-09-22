//Artists Manager

var SMartistsManager = function() {
	
	function setArtistInfo($link, $currentSong) {
		var currentSong = $currentSong;
		// console.log($link);
		//set artist profile info
		var z = $link.href.split('song_id=');
		$link.href = z[0] + 'song_id=';

		//reset favorite song link
		var fav = $("#favorites-box .add-to-favorites");
		var l = fav.attr('href').split('song_id=');
		fav.attr('href', l[0] + 'song_id=')

		if(!currentSong) {
			return false;
		}
		else {
			var calloutBox = $('.callout#show-artist-profile');

			//set favorite song
			fav.attr('href', fav.attr('href').replace('song_id=', 'song_id=' + currentSong['song_id']));

			if(calloutBox.hasClass('visible') && !newArtistProfile) {
				hideCallout();
				$($link).removeClass('current-visit');
				$('.callout#show-artist-profile').removeClass('visible')
				return false;
			}
			else {
				showCallout();
				newArtistProfile = false;
				// console.log($link.href);
				$link.href = $link.href + currentSong['song_id'];
				// console.log($link.href);
				$($link).addClass('current-visit');
			}
		}
	}
	
	function showArtistInfo(song) {
		var songTitle = $('#radio-controls .primary .currently-playing span.song-title');
		var artistName = $('#radio-controls .primary .currently-playing span.artist');
		var songDuration = $('#radio-controls .seek-scrub .seek-val span.duration');
		var songLink = $(".overlay .song-link");
		songTitle.text(song['song_title']);
		artistName.text(song['artist_name']);
		var duration = song['duration'].split(/^0/);
		duration = duration[duration.length - 1];
		songDuration.text(duration);
		songLink.attr('href', song.song_url);
		$(".external-button, #show-slider").addClass("show-button");
		$(".currently-playing").removeClass('first-load');
	}

	function showCallout() {
		var profileWrapper = $('.callout#show-artist-profile').closest('.callout-wrapper');
		centerRadioCallout('expand');
		profileWrapper.find('.spinner').show();
		TweenLite.to($('.radio-wrapper'), 0.5, {left: 0, ease: Sine.easeInOut});
		TweenLite.to($('#player-box, .player, #player-box .player .overlay'), 0.5, {css:{borderBottomRightRadius:0, borderTopRightRadius:0}});
		TweenLite.to(profileWrapper, 0.5, {ease: Sine.easeInOut, right: 0, onComplete: function() {
			var anchor = profileWrapper.find('.anchor');
			TweenLite.to(anchor, 0.3, {opacity:1});
		 	$('.callout#show-artist-profile').addClass('visible').closest('.callout-wrapper').css('z-index', '0');
		}});
	}

	function hideCallout() {
		var anchor = $('.callout#show-artist-profile').closest('.callout-wrapper').find('.anchor');
		$('.callout#show-artist-profile').closest('.callout-wrapper').css('z-index', '-1');
		TweenLite.to(anchor, 0.3, {opacity:0});
		TweenLite.to($('#player-box, .player'), 0.5, {css:{borderBottomRightRadius:10, borderTopRightRadius:10}});
		TweenLite.to( $('.callout#show-artist-profile').closest('.callout-wrapper'), 0.5, {right: '31%', ease: Sine.easeInOut, onComplete: function() {
			calloutBox.find('.container').remove();
		}});
		centerRadioCallout('collapse');

	}
	
	return {
		setArtistInfo: setArtistInfo,
		showArtistInfo: showArtistInfo
	}
}
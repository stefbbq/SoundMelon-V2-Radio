//Artists Manager

var SMartistsManager = function() {
	
	function setArtistInfo($currentSong) {
		var currentSong = $currentSong;
		var $link = $("#get-artist-info")[0];


		if(!currentSong) {
			return false;
		}
		else {
			var calloutBox = $('.callout#show-artist-profile');

			//reset favorite song link
			var fav = $("#add-to-favorites").removeClass('filled');
			var l = fav.attr('href').split('song_id=');
			fav.attr('href', l[0] + 'song_id=');

			//set favorite song
			var favBox = fav.closest('.favorites-link');
			favBox.removeClass('hidden filled');
			fav.attr('href', fav.attr('href').replace('song_id=', 'song_id=' + currentSong['song_id']));
			if(currentSong['favorite'] === 'true') favBox.addClass('filled');

			//reset artist profile link
			// var z = $link.href.split('song_id=');
			// $link.href = z[0] + 'song_id=';
			// $link.href = $link.href + currentSong['song_id'];
			// console.log(currentSong);
			$.ajax({url: '/artist_info?song_id=' + currentSong['song_id']});

			if(calloutBox.hasClass('visible') && !newArtistProfile) {
				// CalloutManager.hideCallout();
				// $($link).removeClass('current-visit');
				// $('.callout#show-artist-profile').removeClass('visible')
				// return false;
			}
			else {
				CalloutManager.showCallout();
				newArtistProfile = false;
				

				// console.log($link.href);
				// $($link).addClass('current-visit');
			}
		}
	}
	
	function showArtistInfo(song) {
		var songTitle = $('#radio-controls .primary .currently-playing .song-title');
		var artistName = $('#radio-controls .primary .currently-playing .artist');
		var songDuration = $('#radio-controls .seek-scrub .seek-val span.duration');
		var songLink = $(".overlay .song-link");
		songTitle.text(song['song_title']);
		artistName.text(song['artist_name']);
		var duration = song['duration'].split(/^0/);
		duration = duration[duration.length - 1];
		songDuration.text(duration);
		songLink.attr('href', song.song_url);
		
		//things to run when the play button is first hit
		$('.primary').css('margin', '0 0 0 18px').css('text-align', 'left').css('width', '65%');
		$(".right a, #show-slider").addClass("show-button");
		$(".currently-playing").removeClass('first-load');
	}

	// function showCallout() {
	// 	var profileWrapper = $('.callout#show-artist-profile').closest('.callout-wrapper');
	// 	centerRadioCallout('expand');
	// 	profileWrapper.find('.spinner').show();
	// 	TweenLite.to($('.radio-wrapper'), 0.5, {left: 0, ease: Sine.easeInOut});
	// 	TweenLite.to($('#player-box, .player, #player-box .player .overlay'), 0.5, {css:{borderBottomRightRadius:0, borderTopRightRadius:0}});
	// 	TweenLite.to(profileWrapper, 0.5, {ease: Sine.easeInOut, right: 0, onComplete: function() {
	// 		var anchor = profileWrapper.find('.anchor');
	// 		TweenLite.to(anchor, 0.3, {opacity:1});
	// 	 	$('.callout#show-artist-profile').addClass('visible').closest('.callout-wrapper').css('z-index', '0');
	// 	}});
	// }

	// function hideCallout() {
	// 	var anchor = $('.callout#show-artist-profile').closest('.callout-wrapper').find('.anchor');
	// 	$('.callout#show-artist-profile').closest('.callout-wrapper').css('z-index', '-1');
	// 	TweenLite.to(anchor, 0.3, {opacity:0});
	// 	TweenLite.to($('#player-box, .player'), 0.5, {css:{borderBottomRightRadius:10, borderTopRightRadius:10}});
	// 	TweenLite.to( $('.callout#show-artist-profile').closest('.callout-wrapper'), 0.5, {right: '31%', ease: Sine.easeInOut, onComplete: function() {
	// 		calloutBox.find('.container').remove();
	// 	}});
	// 	centerRadioCallout('collapse');

	// }
	
	return {
		setArtistInfo: setArtistInfo,
		showArtistInfo: showArtistInfo
	}
}
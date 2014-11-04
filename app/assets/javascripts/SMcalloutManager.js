//Callout Item

var SMcalloutManager = function(calloutBox) {
	// callout is a DOM element with class .callout-wrapper
	var callout = calloutBox;
	var allBoxes = callout.find('.callout');
	var calloutLinks = $(".player-buttons .callout-action");
	// console.log(calloutLinks);
	var active = false;
	var anchor = calloutBox.find('.anchor');

	function enable() {
		calloutLinks.click(toggleCallout);
	}

	function toggleCallout() {
		var link = $(this);
		calloutLinks.removeClass('current-visit');
		link.addClass('current-visit');
		console.log(link);
		allBoxes.hide();
		var relBox = callout.find('#' + link.attr('data-callout-id'));
		relBox.show();
		var linkPos = findPos(link[0]);
		var anchorPos = findPos(anchor[0]);
		var diff = linkPos.y - anchorPos.y;
		console.log(diff);
		// anchor.css('top', '');
		var newTop = parseInt(anchor.css('top')) + diff - 30;
		TweenLite.to(anchor, 0.3, {top: newTop});
	}

	function getActive() {
		return active;
	}

	function setActive(val) {
		active = val;
	}

	function showCallout() {
		// var callout = $('.callout#show-artist-profile').closest('.callout-wrapper');
		centerRadioCallout('expand');
		callout.find('.spinner').show();
		TweenLite.to($('.radio-wrapper'), 0.5, {left: 0, ease: Sine.easeInOut});
		TweenLite.to($('#player-box, .player, #player-box .player .overlay'), 0.5, {css:{borderBottomRightRadius:0, borderTopRightRadius:0}});
		TweenLite.to(callout, 0.5, {ease: Sine.easeInOut, right: 0, onComplete: function() {
			var anchor = callout.find('.anchor');
			TweenLite.to(anchor, 0.3, {opacity:1});
		 	callout.find('.callout').addClass('visible');
		 	callout.css('z-index', '0');
		}});
	}

	function hideCallout() {
		var anchor = callout.find('.anchor');
		callout.css('z-index', '-1');
		TweenLite.to(anchor, 0.3, {opacity:0});
		TweenLite.to($('#player-box, .player'), 0.5, {css:{borderBottomRightRadius:10, borderTopRightRadius:10}});
		TweenLite.to( callout, 0.5, {right: '31%', ease: Sine.easeInOut, onComplete: function() {
			callout.find('.callout .container').remove();
		}});
		centerRadioCallout('collapse');
	}


	return {
		enable: enable,
		showCallout: showCallout,
		hideCallout: hideCallout
	}
}
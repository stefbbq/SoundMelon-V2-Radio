SMsplashManager = (function() {
	var captioBox, slideInterval;
	var captionSelector = '.rotating-caption'
	var slideDelay = 3000;
	var animDur = 0.5;
	var index = 1;
	var maxOpacity = 0.5;
	
	var captions = [
		'Genuine Fans',
		'Local Artists',
		'Hearworthy Music',
		'Free To Use'
	];


	function enable() {
		$(document).ready(function() {
			captionBox = $(captionSelector);
			console.log('captions setup');
			slideInterval = setInterval(changeCaption, slideDelay);
		});
	}

	function changeCaption() {
		if($(captionSelector).length > 0) {
			TweenLite.to(captionBox, animDur, {opacity: 0, onComplete: function() {
				// index = index === captions.length ? 0 : index;
				captionBox.html(captions[index]);
				TweenLite.to(captionBox, animDur, {opacity: maxOpacity})
				console.log(index);
				index = index === captions.length - 1 ? 0 : index + 1;
			}});
		}
		else clearInterval(slideInterval);
	}

	enable();


})();
//
//Flash Message Class

var SMflashManager = (function() {
	return function() {
		//
		//vars
		flashBoard = $('#flash-board');
		var severityBox = flashBoard.find('.severity');
		
		//
		//setup
		function enable() {
			flashBoard.click(dismiss);
			severityBox.click(function() {
				animateOut(0);
			});

		}
		function disable() {
			flashBoard.ubnind('click');
		}
		
		//
		//behaviour
		function showMessage(message) {
			 TweenLite.killTweensOf(flashBoard);
			var severity = message.severity;
			
			switch(severity) {
				case "notification":
					flashBoard.addClass('notification').removeClass('error warning');
					break;
				case "warning":
					flashBoard.addClass('warning').removeClass('error notification');
					break;
				case "error":
					console.log(severity);
					flashBoard.addClass('error').removeClass('notification warning');
					break;
			}
			flashBoard.find('.severity .level').html(severity);
			flashBoard.find('.message').html(message.message);
			var delay = severity === 'error' ? 999 : 5;
			animateIn(animateOut, delay);
			// animateIn();
		}
		
		function dismiss() {
			animateOut();
		}
		
		
		//
		//animations
		function animateIn(callback, delay){
			// $('.footer .menu').css('visibility', 'hidden');
			flashBoard.show();
			TweenLite.from(flashBoard, 0.4, {top: -flashBoard.height(), onComplete: callback, onCompleteParams: [delay]});
		}
		
		function animateOut(delay){
			var anim = TweenLite.to(flashBoard, 0.4, {top: -flashBoard.height(), onComplete: function(){
				flashBoard.hide();
				flashBoard.css('top', 0);
				$('.footer .menu').css('visibility', 'visible');
			}}).delay(delay);

			if(delay === 999) {
				TweenLite.killDelayedCallsTo(flashBoard);
			}
			
		}
		
		enable();
		
		return {
			//functions
			enable: enable,
			disable: disable,
			showMessage: showMessage
		}
	}
})();
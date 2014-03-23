var SMflashManager = (function() {
	return function() {
		//
		//vars
		flashBoard = $('#flash-board');
		
		//
		//setup
		function enable() {
			flashBoard.click(dismiss);
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
			animateIn(animateOut);
		}
		
		function dismiss() {
			animateOut();
		}
		
		
		//
		//animations
		function animateIn(callback){
			$('.footer .menu').css('visibility', 'hidden');
			flashBoard.show();
			TweenLite.from(flashBoard, 0.4, {top: 200, onComplete: callback});
		}
		
		function animateOut(){
			TweenLite.to(flashBoard, 0.4, {top: 200, onComplete: function(){
				flashBoard.hide();
				flashBoard.css('top', 0);
				$('.footer .menu').css('visibility', 'visible');
			}, delay: 2});
			
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
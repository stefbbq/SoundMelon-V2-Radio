//
//Flash Message Class

var SMflashManager = (function() {
	return function() {
		//
		//vars
		var currentMessage;
		flashBoard = $('#flash-board');
		var severityBox = flashBoard.find('.severity');
		var severities = ['warning', 'notification', 'error'];
		
		//
		//setup
		function enable() {
			flashBoard.click(dismiss);
			severityBox.click(defaultClick);

		}
		function disable() {
			flashBoard.ubnind('click');
		}
		
		//
		//behaviour
		function showMessage(message) {
			 TweenLite.killTweensOf(flashBoard);
			var severity = message.severity;
			currentMessage = message;
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
			// var delay = severity !== 'warning' || severity !== 'notification' ? 999 : 5;
			var delay = ['warning', 'notification'].indexOf(severity) === -1 ? 999 : 5;
			var delay = message.delay ? message.delay : delay;
			animateIn(animateOut, delay);
			if(severities.indexOf(severity) === -1 && message.click) {
				severityBox.unbind('click', defaultClick);
				severityBox.click(customClick);
			}
			// animateIn();
		}
		
		function dismiss() {
			animateOut();
		}
		
		function defaultClick() {
			animateOut(0);
		}

		function customClick() {
			console.log(currentMessage.click);
			$(currentMessage.click).click();
			animateOut(0);
			severityBox.unbind('click');
			severityBox.click(defaultClick);
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
			showMessage: showMessage,
			animateOut: animateOut
		}
	}
})();
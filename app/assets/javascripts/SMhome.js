var FlashManager, ModalManager;

$(document).ready(function() {
	FlashManager = new SMflashManager();
	ModalManager = new SMmodalManager();
	
	//Add AJAX-loaders
	$(document).ajaxStop(spinnerAjaxStop);

	//setup GA events
	$("#learn-more a").click(function() {
		ga('send', 'event', 'button', 'click', 'about-soundmelon');
	});
	$("#sign-in a").click(function() {
		ga('send', 'event', 'button', 'click', 'signin-signup');
	});

});
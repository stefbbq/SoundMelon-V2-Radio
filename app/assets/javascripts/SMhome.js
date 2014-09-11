var FlashManager, ModalManager;

$.fn.justify = function() {
	$(this).css("text-align", "justify");
	// $(this).find('.justify-span').css('display', 'inline-block');
	$(this).append("<span style='display: inline-block;visibility: hidden;width:100%'></span>");
}

function initHomeFunctionality() {

	$(".link-box").css({
		display: 'inline-block',
		visibility: 'visible'
	});
	TweenLite.to('.link-box', 0.5, {opacity:1, onComplete: function() {
		$('.link-box').addClass('visible-box');
	}});

	ModalManager.enable();
	RadioManager.enable();

	$(document).mouseup(function(e) {
		var container = $('.modal, .volume-controls, .report-box');
		if(!container.is(e.target) && container.has(e.target).length == 0) {
			container.hide();
		}
	});
}

$(document).ready(function() {
	FlashManager = new SMflashManager();
	console.log('setting up modals now...');
	ModalManager = SMmodalManager();

	//justify text
	// $("#sm-social-cta .justify").justify();

	//Setup artist profile notification
	if($(".warn-user").length > 0) {
		$('.warn-user').each(function() {
			var warning = $(this);
			var delay = warning.hasClass('warn-artist') ? 30000 : 120000;
			setTimeout(function() {
				FlashManager.showMessage({
					message: warning.find('.message').html(),
					severity: warning.find('.severity').html(),
					click: warning.find('.click').attr('data-click'),
					delay: 15
				});
			}, delay);
		});
	}
	
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
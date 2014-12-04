var FlashManager, ModalManager;

$.fn.justify = function() {
	$(this).css("text-align", "justify");
	// $(this).find('.justify-span').css('display', 'inline-block');
	$(this).append("<span style='display: inline-block;visibility: hidden;width:100%'></span>");
}

function initHomeFunctionality() {
	// console.log("I'm being inited");
	// console.log($(".link-box"));
	showFooterLinks();

	ModalManager.enable();
	RadioManager.enable();

	setOuterBoxClick();
}

function showFooterLinks() {
	$(".link-box").css({
		display: 'inline-block',
		visibility: 'visible'
	});
	TweenLite.to('.link-box', 0.5, {opacity:1, onComplete: function() {
		$('.link-box').addClass('visible-box');
	}});
}

function setOuterBoxClick() {
	$(document).mouseup(function(e) {
		var container = $('.modal, .volume-controls, .report-box');
		if(!container.is(e.target) && container.has(e.target).length == 0) {
			container.hide();
		}
	});
}

function animateSplashOut(callback) {
	FlashManager.animateOut(0);
	TweenLite.to('.inner-content', 0.4, {opacity: 0});
	$(".login-spinner").css('display','block');
	TweenLite.to('.login-spinner', 0.2, {opacity: 1});
	splashBGtween = TweenLite.to('.bg-wrapper', 1, {opacity: 1, delay: 0.5, ease:Sine.easeInOut, onComplete: function() {
			callback();
			$(".splash-bg").css('opacity',0);
	}});	
}

function animateHomeIn() {
	TweenLite.fromTo($('.main_page_div'), 1, {opacity:0}, {opacity:1, ease:Sine.easeInOut});	
}

function hideInstruction(input) {
	var instruction = $(input).closest('.form-inputs').find('.instruction');
	TweenLite.to(instruction, 0.6, {opacity: 0});
	$(input).closest('.form-inputs').removeClass('field-error');
}

function showInstruction(input) {
	var instruction = $(input).closest('.form-inputs').find('.instruction');
	TweenLite.to(instruction, 0.6, {opacity: 1});
	if($(input).closest('.joined-inputs').length > 0) {
		$(input).closest('.joined-inputs').addClass('field-error');
	}
}

function checkConfEmail(e) {
	var form = $(this);
	if(!runEmailConf) e.preventDefault();

}

function runEmailConf(form) {
	var email = form.find('[name="user[email]"]');
	var emailVal = email.val().toLowerCase();
	email.val(emailVal);
	var emailConf = form.find('[name="user[email_confirmation]"]').val().toLowerCase();
	form.find('[name="user[email_confirmation]"]').val(emailConf);
	if(emailVal !== emailConf || emailConf === '') {
		showInstruction(email);
		return false;
	}
	else hideInstruction(email);
}

$(document).ready(function() {
	FlashManager = new SMflashManager();
	// console.log('setting up modals now...');
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

	if($('html').hasClass('ipad')) {
		$(window).blur(function() {
			$(window).scrollTop(0);
			console.log('blur out scroll top');
		}).focus(function() {
			$(window).scrollTop(0);
			console.log('focus in scroll top');
		});
	};
	
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
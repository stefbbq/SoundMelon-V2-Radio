var FlashManager, ModalManager;

$(document).ready(function() {
	FlashManager = new SMflashManager();
	ModalManager = new SMmodalManager();
	RadioManager = new SMradioManager($('#soundcloud').attr('data-app-id'));
	RadioManager.enable();
	
//Add AJAX-loaders
$(document).ajaxStop(spinnerAjaxStop);

});
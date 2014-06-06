var FlashManager, ModalManager;

$(document).ready(function() {
	FlashManager = new SMflashManager();
	ModalManager = new SMmodalManager();
	RadioManager = new SMradioManager($('#soundcloud').attr('data-app-id'));
	ModalManager.enable();
	RadioManager.enable();
	
//Add AJAX-loaders
$(document).ajaxStop(spinnerAjaxStop);

});
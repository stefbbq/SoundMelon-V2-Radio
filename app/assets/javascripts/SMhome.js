var FlashManager, ModalManager;

$(document).ready(function() {
	FlashManager = new SMflashManager();
	RadioManager = new SMradioManager($('#soundcloud').attr('data-app-id'));
	ModalManager = new SMmodalManager();
	
//Add AJAX-loaders
$(document).ajaxStop(spinnerAjaxStop);

});
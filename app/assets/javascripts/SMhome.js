var FlashManager, ModalManager;

$(document).ready(function() {
	FlashManager = new SMflashManager();
	ModalManager = new SMmodalManager();
	
//Add AJAX-loaders
$(document).ajaxStop(spinnerAjaxStop);

});
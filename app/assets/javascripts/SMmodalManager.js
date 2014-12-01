//
//Modal Manager

var SMmodalManager = function() {
	var modalItems = {};
	
	//
	//behaviour
	function enable(){
		initBehaviour();
	}
	function initBehaviour(){
		var modalLinks = $('.modal-link');
		var count = 0;
		var modalItemsKeys = Object.keys(modalItems);
		for(var i=0; i < modalLinks.length; i++) {
			var modalId = $(modalLinks[i]).attr('id');
			if($.inArray(modalId, modalItemsKeys) === -1) {
				createNewItem(modalLinks[i], i);	
				count += 1;
			}
			
		}
		// console.log('modal links length: ' + count);
	}
	
	
	//
	//config
	function createNewItem($item, $index) {
		var modalItem = new SMmodalItem($($item), $index);
		modalItem.enable();
		modalItems[modalItem.modalId] = modalItem;
		// modalItems.push(modalItem);
	}
	
	// enable();
	
	return {
		//functionas
		enable: enable,
		//variables
		modalItems: modalItems
	}
};
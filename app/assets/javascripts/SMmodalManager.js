//
//Modal Manager

var SMmodalManager = (function(){
	return function() {
		var modalItems = [];
		
		//
		//behaviour
		function enable(){
			initBehaviour();
		}
		function initBehaviour(){
			var modalLinks = $('.modal-link');
			for(var i=0; i < modalLinks.length; i++) {
				createNewItem(modalLinks[i], i);
			}
		}
		
		
		//
		//config
		function createNewItem($item, $index) {
			var modalItem = new SMmodalItem($($item), $index);
			modalItem.enable();
			modalItems.push(modalItem);
		}
		
		enable();
		
		return {
			//functionas
			enable: enable,
			//variables
			modalItems: modalItems
		}
	}
})();
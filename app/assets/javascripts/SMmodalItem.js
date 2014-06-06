//
//Modal Class

SMmodalItem = function($link, $index){
	var base, link, object, index, name, active;
	index = $index;
	active = false;
	
	base = this;
	link = $link;
	name = link.attr('data-modal');
	object = $('#' + name);
	
	//
	//config
	function enable() {
		initBehaviour();
	}
	function initBehaviour() {
		link.click(toggleModal);
		$(document).mouseup(function($e) {
			smartHide($e);
		});
	}
	
	//
	//behaviour
	function toggleModal(){
		if(!isActive()) {
			object.show();
			activate();
			console.log(isActive());
			if(isLoaded()) {
				return false;
			}
			else {
				object.find('.spinner').show();
			}
		}
		else {
			object.hide();
			deactivate();
		}
	}
	
	function isLoaded() {
		return ( !object.find('.main-content .content').is(':empty') );
	}
	
	function smartHide($e) {
		if(!object.is($e.target) && object.has($e.target).length === 0) {
			object.hide();
			deactivate();
		}
	}
	
	function activate() {
		active = true;
	}
	
	function deactivate() {
		active = false;
	}
	
	function isActive() {
		return active;
	}
	
	return {
		//functions
		enable: enable,
		activate: activate,
		deactivate: deactivate,
		//variables
		index: index
	}
}
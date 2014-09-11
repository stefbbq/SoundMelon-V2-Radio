//
//Modal Class

SMmodalItem = function($link, $index){
	var base, link, object, index, name, active, sidebar, linkBox, linkBoxes;
	index = $index;
	active = false;
	
	base = this;
	link = $link;
	name = link.attr('data-modal');
	object = $('#' + name);
	sidebar = object.find('.sidebar');
	
	linkBox = $link.closest('.link-box');
	linkBoxes = $(".footer .menu .link-box");

	//
	//config
	function enable() {
		initBehaviour();
	}
	function initBehaviour() {
		link.click(toggleModal);
		setModalClose();
		setModalPosition();
		$(window).resize(setModalPosition);
		$(document).ready(function() {

		});

	}
	
	//
	//behaviour
	function toggleModal(){
		if(!isActive()) {
			object.show();
			// console.log('activating from: ' + isActive());
			activate();
			linkBoxes.removeClass('menu-active');
			if(linkBox.hasClass('hover-red')) linkBox.addClass('menu-active');
			else linkBox.addClass('menu-active');
			if(isLoaded()) {
				return false;
			}
			else {
				object.find('.spinner').show();
			}
		}
		else {
			console.log('deactivating from: ' + isActive());
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

	function setModalClose() {
		$(document).click(function(e) {
			// console.log("document clicked");
			object.each(function() {
				var $el = $(this);
				// console.log($el);
				if( 
						this !== e.target &&
	        	!$el.has(e.target).length &&
	          ( !$(e.target).is('.modal, .go-back') )
	        ) {
					// $el.removeClass(disableClass);
					// console.log('hiding: ' + name);
					linkBox.removeClass('menu-active');
					object.hide();
					if(name === "artist-profile" && active) {
						FlashManager.showMessage({
							message: "Your profile has been updated",
							severity: "notification"
						});
					}
					deactivate();
				}
			});
		});
	}

	function setModalPosition() {
		var linkIndex = linkBox.index();
		var linkBoxesLength = linkBoxes.length;
		if(linkIndex < linkBoxesLength - 2 || innerWidth < 801) {
			console.log(linkBox.index());
			var linkPos = findPos($link[0]);
			var offset = 100;
			var linkLeftPos = linkPos.x - offset;
			object.css('left', linkLeftPos);
		}
		else if(linkIndex === linkBoxesLength - 2 && innerWidth > 800) {
			object.addClass('second-last-modal');
		}
		else {
			object.addClass('last-modal');
		}
	}
	
	function activate() {
		active = true;
	}
	
	function deactivate() {
		active = false;
		linkBox.removeClass('menu-active menu-active');
		object.hide();
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
		index: index,
		modalId: object.attr('id')
	}
}
//
//Modal Class

SMmodalItem = function($link, $index){
	var base, link, object, index, name, active, sidebar;
	index = $index;
	active = false;
	
	base = this;
	link = $link;
	name = link.attr('data-modal');
	object = $('#' + name);
	sidebar = object.find('.sidebar');
	
	//
	//config
	function enable() {
		initBehaviour();
	}
	function initBehaviour() {
		link.click(toggleModal);
		setModalClose();
		// setSidebar();
		// $(document).mouseup(function($e) {
		// 	smartHide($e);
		// });
	}
	
	//
	//behaviour
	function toggleModal(){
		if(!isActive()) {
			object.show();
			console.log('activating from: ' + isActive());
			activate();
			$('.footer .menu a').removeClass('active-red active-green');
			if(link.hasClass('hover-red')) link.addClass('active-red');
			else link.addClass('active-green');
			if(isLoaded()) {
				return false;
			}
			else {
				object.find('.spinner').show();
			}
		}
		else {
			console.log('deactivating from: ' + isActive());
			link.removeClass('active-red active-green');
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

	function setModalClose() {
		$(document).click(function(e) {
			object.each(function() {
				var $el = $(this);

				if( 
						this !== e.target &&
	        	!$el.has(e.target).length &&
	          ( !$(e.target).is('.modal') )
	        ) {
					// $el.removeClass(disableClass);
					link.removeClass('active-red active-green');
					object.hide();
					deactivate();
				}
			});
		});
	}

	// function setVendorClose(box, boxClass, disableClass) {
	// 	jQuery(document).click(function(e) {
	// 		box.each(function() {
	// 			var $el = jQuery(this);

	// 			if( this !== e.target &&
	//         	!$el.has(e.target).length &&
	//           !$(e.target).is('.modal')) {
	// 				$el.removeClass(disableClass);
	// 			}
	// 		});
	// 	});
	// }
	
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
		index: index,
		modalId: object.attr('id')
	}
}
var SMflashManager=function(){return function(){function a(){flashBoard.click(s)}function e(){flashBoard.ubnind("click")}function o(a){TweenLite.killTweensOf(flashBoard);var e=a.severity;switch(e){case"notification":flashBoard.addClass("notification").removeClass("error warning");break;case"warning":flashBoard.addClass("warning").removeClass("error notification");break;case"error":console.log(e),flashBoard.addClass("error").removeClass("notification warning")}flashBoard.find(".severity .level").html(e),flashBoard.find(".message").html(a.message),n(i)}function s(){i()}function n(a){$(".footer .menu").css("visibility","hidden"),flashBoard.show(),TweenLite.from(flashBoard,.4,{top:200,onComplete:a})}function i(){TweenLite.to(flashBoard,.4,{top:200,onComplete:function(){flashBoard.hide(),flashBoard.css("top",0),$(".footer .menu").css("visibility","visible")},delay:2})}return flashBoard=$("#flash-board"),a(),{enable:a,disable:e,showMessage:o}}}();
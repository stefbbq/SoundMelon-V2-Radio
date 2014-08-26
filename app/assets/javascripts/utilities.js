function arr_difference(a1, a2) {
	//Return an array that is the difference of a1 and a2
	difference = $.grep(a1,function(x) {return $.inArray(x, a2) < 0})
	return difference
}

function shuffleList(lst) {
	var new_lst = lst;
	for (var i = new_lst.length - 1; i > 0; i--) {
		var j = Math.floor(Math.random() * (i + 1));
		var temp = new_lst[i];
		new_lst[i] = new_lst[j];
		new_lst[j] = temp;
	}
	return new_lst;
}

function secToMinSec(sec) {
	//Convert seconds to Minutes:Seconds in 00:00 format
	var sec1 = Math.floor(sec);
	var mins = Math.floor(sec1 / 60);
	var secs = sec1 % 60;
	if(secs < 10) {
		secs = '0' + secs;
	}
	var time = mins + ':' + secs;
	return time;
}

function spinnerAjaxStop() {
	$('.spinner').hide();
}

function findPos(obj) {
	var curLeft = curTop = 0;
	if (obj.offsetParent) {
		do {
			curLeft += obj.offsetLeft;
			curTop += obj.offsetTop;
		} while (obj = obj.offsetParent);
	}
	return {x:curLeft, y:curTop};
}

function centerRadioCallout(command) {
	var totalWidth = command === "expand" ? $(".radio-wrapper").width() + $('.callout-wrapper').width() : $(".radio-wrapper").width();
	// $(".main-content").width(totalWidth);
	TweenLite.to($('#page-content'), 0.5, {width: totalWidth})
}
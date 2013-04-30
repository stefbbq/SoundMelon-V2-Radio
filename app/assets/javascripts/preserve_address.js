$('document').ready(function(){
	$('.page_link').click(function(e){
		url = $(this).attr("href");
		console.log(e.target.href);
		history.pushState(null, "", e.target.href);
		e.preventDefault();
	});
	$(window).bind('popstate', function(event) {
		console.log(location.href);
		$.getScript(location.href);
	});
});

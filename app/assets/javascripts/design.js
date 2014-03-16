//functions
var pr = 0, bgWidth = true, bgResize;

bgResize = function(){
  var wr = $(window).width() / $(window).height();

  if(wr > pr && !bgWidth) {
    $('.bg-img').css('width', '100%').css('height', '');
    bgWidth = true;
  } else if (wr < pr && bgWidth) {
    $('.bg-img').css('width', '').css('height', '100%');
    bgWidth = false;
  }
};

//events
$('document').ready(function(){
  $('.bg-img').load(function(){
    pr = $('.bg-img').width() / $('.bg-img').height();
		bgResize();
  });

  $(window).resize(bgResize);
});
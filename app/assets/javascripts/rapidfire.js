//= require jquery
//= require jquery_ujs
//
$(function() {
  $(".question:not(.kernel)").has(".introduction").each(function(){
     var q = $(this);
     var current_margin_top = parseInt(q.css("margin-top"));
     q.css("margin-top", (current_margin_top + 30) + 'px' );
  })
});

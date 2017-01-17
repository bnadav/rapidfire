//= require jquery
//= require jquery_ujs
//
$(function() {
 set_top_margin_on_questions_with_introduction();
 jump_to_error_anchor();
});

function set_top_margin_on_questions_with_introduction() {
  $(".question:not(.kernel)").has(".introduction").each(function(){
     var q = $(this);
     var current_margin_top = parseInt(q.css("margin-top"));
     q.css("margin-top", (current_margin_top + 30) + 'px' );
  })
}


function jump_to_error_anchor() {
  if($("a[name='input_error']")[0]) {
     location.hash = "#input_error"; 
  }
}


$(function() {
  var key = "Cocos2d-x_pg_lang";
  var switch_lang = function(l) {
      $('.langs li a').removeClass('selected');
      $('#'+l).addClass('selected');
      $('.tab_content').hide();
      $('.'+l).show();
      $.cookie(key, l);
  }
  $('.langs li a').click(function() {switch_lang(this.id);return false;});
  var c = $.cookie(key);
  if (typeof c == 'undefined') c='tab-cpp';
  switch_lang(c);
});

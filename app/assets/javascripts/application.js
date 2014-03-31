//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.ui.autocomplete
//= require jquery.bgiframe.min
//= require_tree .

jQuery(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  return $("a[rel=tooltip]").tooltip();
});

$(document).ready(function() {
  return $(":file").filestyle({
    icon: true,
    classIcon: "icon-file",
    buttonText: "Choose file..."
  });
});

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var ready;
ready = function() {
  document.onkeydown = function(evt) {
    evt = evt || window.event;
    console.log(evt.keyCode);
    switch (evt.keyCode) {
        case 37:
          $('#move-left').click();
          break;
        case 39:
          $('#move-right').click();
          break;
        case 40:
          $('#move-down').click();
          break;
        case 38:
          $('#move-up').click();
          break;
    }
  };

  if ($('.reload-page').length > 0) {
    window.setTimeout(location.reload(), 500);
  }
}

$(document).ready(ready);
$(document).on('page:load', ready);
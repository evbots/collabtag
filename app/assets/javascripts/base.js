$(document).on('ready page:load', global_init);

function global_init() {
  set_global_click_handlers();
  set_menu_prefs();
  check_group();
  profile_init();

  $.ajaxSetup({ cache: true });
  $.getScript('//connect.facebook.net/en_US/sdk.js', function(){
    FB.init({
      appId: '105528653116478',
      version: 'v2.3' // or v2.0, v2.1, v2.0
    });
    FB.getLoginStatus(updateStatusCallback);
  });

  function share_to_facebook() {
    FB.ui({
      method: 'share',
      href: window.location.href,
    }, function(response){});
  }

  function updateStatusCallback() {
    return '';
  }
  
  function set_global_click_handlers() {
    $('body').on('click', 'a#facebook-share', function(event) {
      event.preventDefault();
      share_to_facebook();
      return false;
    });
  }

  function adjust_nav() {
    if ($('.affix').is(':visible')) {
      return $('.explore-container').css('line-height', $('.affix').height().toString() + 'px');
    }
  }

  function set_menu_prefs() {
    $('#fancynav').affix({});

    adjust_nav();
    $( window ).resize(function() {
      adjust_nav();
    });

    $("#mobile-menu-trigger").on('click', function(e) {
      e.preventDefault();
      $( ".mobile-menu" ).addClass('mobile-menu-open');
      adjust_nav();
    });

    $('.top-mobile-menu-close-button, .mobile-menu-close-button').on('click', function(e) {
      e.preventDefault();
      $( ".mobile-menu" ).removeClass('mobile-menu-open');
    });
  }
}

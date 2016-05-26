function profile_init() {
  // Only execute if on profile page
  if ($('.profile-page').length) {
    profile_code();
  }

  function profile_code() {
    var profile_ajax = false,
        username_text = $('#username-container').attr('data-username'),
        last_timestamp = 0,
        spinner = $('.ajax-spinner');

    spinner.hide();

    function get_profile_posts() {
      if (profile_ajax == true || last_timestamp == 'empty') {
        return false;
      }

      spinner.show();
      profile_ajax = true;

      var params = {
        user_name: username_text,
        timestamp: last_timestamp
      };

      var options = {
        type: "GET",
        dataType: "json",
        cache: false,
        url: '/posts/paginate_profile',
        data: params
      };

      $.ajax(options).always(function() {
        // Stop spinner and allow more requests
        spinner.hide();
        profile_ajax = false;
      }).done(function(data) {
        last_timestamp = data.last_timestamp;
        var $new_html = $(data.html);
        linkify_posts($new_html);
        $('.user-posts').append($new_html);
        $new_html.show();
      });
    }

    // Set click handlers on load
    set_click_event_handlers();
    // Call once on profile load
    get_profile_posts();

    // Paginate on scroll
    $(window).scroll(function(){
      if ($(window).scrollTop() == $(document).height() - $(window).height()){
        if (profile_ajax == false) {
          get_profile_posts();
        }
      }
    });
  }
}

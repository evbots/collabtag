function check_group() {
  if ($('.group-page').length > 0) {
    group_activity_init();
  }
}

function group_activity_init() {
  var last_timestamp = 0,
      group_ajax = false,
      spinner = $('.ajax-spinner');

  spinner.hide();

  function getPosts() {
    if (group_ajax == true || last_timestamp == 'empty') {
      return false;
    }

    spinner.show();
    group_ajax = true;

    var params = {
      group_id: group_id,
      timestamp: last_timestamp
    }

    var options = {
      type: 'GET',
      dataType: 'json',
      cache: false,
      url: '/posts/paginate.json',
      data: params
    }

    $.ajax(options).always(function() {
      spinner.hide();
      group_ajax = false;
    }).done(function(data) {
      last_timestamp = data.last_timestamp;
      var $new_html = $(data.html);
      linkify_posts($new_html);
      $('.activity-stream').append($new_html);
      $new_html.show();
    });
  }

  function add_post_to_page(data) {
    last_timestamp = data.last_timestamp;
    var $new_html = $(data.html);
    linkify_posts($new_html);
    $('.activity-stream').prepend($new_html);
    $new_html.fadeIn();
  }

  function sendPost() {
    var postBody = $('#post-body').val();
    if (postBody === '') return;
    $('#post-body').val('');
    $.ajax({
      type: "POST",
      dataType: "json",
      cache: false,
      url: '/posts.json',
      data: { body: postBody, group_id: group_id }
    }).done(function(data) {
      if ($('.welcome-message').length > 0) {
        $('.welcome-message').fadeOut(300, function() {
          add_post_to_page(data);
        });
      } else {
        add_post_to_page(data);
      }
    }).fail(function(request_object) {
      alert(request_object.responseJSON.message);
    });
  }

  set_click_event_handlers();

  // Call posts once on page load
  if ($('.welcome-message').length < 1) {
    getPosts();
  }
  
  // Paginate on scroll
  $(window).scroll(function(){
    if ($(window).scrollTop() == $(document).height() - $(window).height()){
      if (group_ajax == false) {
        getPosts();
      }
    }
  });

  // new post click
  $("#send-post").on("click", function() {
    sendPost();
  });
}

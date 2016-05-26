function deletePost(post_id) {
  $.ajax({
    type: 'DELETE',
    dataType: 'json',
    url: '/posts/' + post_id
  }).done(function(msg) {
    $('#post_' + msg.post_id).fadeOut("fast", function() {
      $(this).remove();
    });
  });
}

function set_click_event_handlers() {
  $('body').on('click', 'a.delete-post', function(event) {
    event.preventDefault();
    $post_id = $(this).attr('data-post-id');
    deletePost($post_id);
    return false;
  });
}

function linkify_post_body($body) {
  $body.linkify({
    target: "_blank"
  });
}

function show_image_links($body) {
  $link_array = $body.find('a');
  $.each($link_array, function(index, value) {
    // if link is image, place in comment
    var href = $(value).attr('href');
    if ( image_is_url(href) ) {
      $(value).after('<br><img src="' + href + '"><br>');
    }
  });
}

function image_is_url(link_url) {
  var url_type = link_url.substr((~-link_url.lastIndexOf(".") >>> 0) + 2).toLowerCase();
  var image_types = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff'];
  return $.inArray(url_type, image_types) > -1
}

function linkify_posts(new_html) {
  $posts = new_html.find('.post_body');
  $.each($posts, function(index, value) {
    $new_value = $(value);
    linkify_post_body($new_value);
    show_image_links($new_value);
  });
}

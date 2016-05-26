var countries = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.whitespace,
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  prefetch: '/account/typeahead_data'
});

// passing in `null` for the `options` arguments will result in the default
// options being used
$('.typeahead').typeahead({
  hint: true,
  highlight: true,
  minLength: 1
}, {
  name: 'countries',
  limit: 15,
  source: countries
});

$('.typeahead').bind('typeahead:select', function(ev, suggestion) {
  $(this).addClass('real-school-selected');
  $('.school-form').submit();
});

$('.facebook-form').find('form').on('submit', function(e) {
  if (!$(this).find('.tt-input').hasClass('real-school-selected')) {
    e.preventDefault();
  }
});

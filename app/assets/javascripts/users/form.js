$(document).on('click','#two-factor-toggle', function() {
  $('#user_phone').prop('readonly', !$(this).prop('checked'));
});


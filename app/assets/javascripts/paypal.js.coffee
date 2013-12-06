# disable the submit button when clicked to verify email
$(".paypal-confirm-modal form.paypal-email").livequery ->
  $(this).submit ->
    if $(this).find("#payment_email").val() != ""
      $(this).find("input[type='submit']").attr "disabled", true
      $(this).closest("form").find("input[type='text']").attr "readonly", "readonly"

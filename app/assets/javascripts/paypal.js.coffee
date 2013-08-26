# disable the submit button when clicked to verify email
$(".paypal-confirm-modal .paypal-email input.submit-payment-email").livequery ->
  $(this).click ->
    $(this).attr "disabled", true
    $(this).val "Processing..."
    $(this).closest("form").submit()
    $(this).closest("form").find("input[type='text']").attr "disabled", true

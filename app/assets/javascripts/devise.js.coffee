# disable the submit button when clicked to sign up or sign in
$("form#new_user").livequery ->
  $(this).submit ->
    $(this).find("input.sign-up-submit-button").attr "disabled", true
    $(this).find("input.sign-up-submit-button").val "Processing..."
    $(this).find("input.sign-in-submit-button").attr "disabled", true
    $(this).find("input.sign-in-submit-button").val "Processing..."

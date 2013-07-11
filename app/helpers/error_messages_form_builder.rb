class ErrorMessagesFormBuilder < ActionView::Helpers::FormBuilder
  def error_messages
    return unless object.respond_to?(:errors) && object.errors.any?

    errors_list =  "<div class='alert alert-error'>"
    errors_list << "  <span class='error-title'>There were problems with your request:</span>"
    errors_list << "    <ul class='errors-list'>"
    errors_list <<        object.errors.full_messages.map{ |message| "<li>#{message}</li>" }.join("\n")
    errors_list << "    </ul>"
    errors_list << "  </span>"
    errors_list << "</div>"

    errors_list
  end
end

# Simplecov configuration
SimpleCov.start 'rails' do
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_filter "/lib/development_mail_interceptor.rb"
  add_filter "Rakefile"
  add_filter "/app/helpers/error_messages_form_builder.rb"

  add_filter "app/models/mercury/image.rb"
  add_filter "app/controllers/mercury/images_controller.rb"

  add_group "Models",      "app/models"
  add_group "Views",       "app/views"
  add_group "Controllers", "app/controllers"
  add_group "Helpers",     "app/helpers"
  add_group "Mailers",     "app/mailers"
  add_group "Libraries",   "lib"
  add_group "Rake Tasks",  "lib/tasks"
end

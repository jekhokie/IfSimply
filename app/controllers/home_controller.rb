class HomeController < ApplicationController
  def index
  end

  def registration_notify
  end

  def access_violation
    @violation = params[:exception]
  end

  def terms_and_conditions
  end
end

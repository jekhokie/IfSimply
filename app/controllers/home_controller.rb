class HomeController < ApplicationController
  def index
  end

  def after_devise
  end

  def registration_notify
  end

  def access_violation
    @violation = params[:exception]
  end

  def terms_and_conditions
  end

  def privacy_policy
  end

  def dmca_policy
  end

  def faq
  end

  def free_ebook
    redirect_to root_path unless (params[:keycode] and params[:keycode] == Settings[:general].free_ebook_keycode)
  end
end

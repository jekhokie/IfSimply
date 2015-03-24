class HomeController < ApplicationController
  def index
  end

  def after_devise
  end

  def registration_notify
  end

  def club_registration_notify
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

  def download_ebook
    if (Rails.env.development? and request.env["SERVER_NAME"] == "localhost") or
       request.env["SERVER_NAME"] =~ /[www\.]?ifsimply.com/

      filename = "6_Essential_Elements_Ebook.pdf"
      File.open(File.join(Rails.root, 'private', filename), 'r') do |f|
        send_data f.read.force_encoding('BINARY'), :filename    => filename,
                                                   :type        => "application/pdf",
                                                   :disposition => "attachment"
      end
    else
      redirect_to root_path and return
    end
  end
end

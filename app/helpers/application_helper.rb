module ApplicationHelper
  def flash_class(level)
    case level
      when :notice  then "alert alert-info"
      when :success then "alert alert-success"
      when :error   then "alert alert-error"
      when :alert   then "alert alert-error"
    end
  end

  def resource_name
    :user
  end

  def resource_class
    @devise_mapping.to
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def trim_length(content, max_length)
    content.length > max_length ? "#{content[0...max_length]}..." : content
  end
end

module ActionView
  class Base
    def markdown_to_html(markdown)
      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      renderer.render(markdown)
    end
  end
end

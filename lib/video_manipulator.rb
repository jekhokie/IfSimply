module VideoManipulator
  def self.validate_url(video_url)
    return false if video_url.blank?

    begin
      url = URI.parse video_url
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
    rescue
      return false
    end

    return true
  end
end

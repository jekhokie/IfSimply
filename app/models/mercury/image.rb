class Mercury::Image < ActiveRecord::Base
  self.table_name = :mercury_images

  attr_accessible :image

  has_attached_file :image, :styles      => { :medium => "300x300>", :thumb => "100x100>", :icon => "50x50>" },
                            :path        => ":rails_root/public/system/:attachment/:attachment_id/:id/:style/:hash.:extension",
                            :url         => "/system/:attachment/:attachment_id/:id/:style/:hash.:extension",
                            :hash_secret => "soighow3th2t8hgo2ih#JT(T#y09yt09#)(TY#)(TY)#(G()GVh03gh)(QY(@)YRT()G#H#()g",
                            :default_url => Settings.clubs[:default_logo]

  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'image/tiff' ]

  delegate :url, :to => :image

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= []
    options[:methods] << :url
    super(options)
  end
end

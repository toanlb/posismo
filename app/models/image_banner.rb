class ImageBanner < Banner
  mount_uploader :image, ImageUploader

  attr_accessible :name, :description, :image, :image_size

  before_save :update_image_size

  def update_image_size
    if self.image.blank?
      self.image_size = nil
    else
      self.image_size = "#{self.image.width}x#{self.image.height}"
    end
  end
  
  def resize_image
    width = self.image_size.split("x").first.to_i
    height = self.image_size.split("x").last.to_i
    if width/height >= 180/135
      height = height*180/width
      width = 180
    else
      width = width*135/height
      height = 135
    end
    return width.to_s+"x"+height.to_s
  end
end

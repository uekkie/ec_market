class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process convert: 'png'
  process tags: ['post_image']

  version :standard do
    process resize_to_fill: [100, 150, :north]
  end

  version :preview do
    process resize_to_fit: [150, 150]
  end

  version :thumbnail do
    process resize_to_fit: [50, 50]
  end

  def public_id
    model.id
  end
end

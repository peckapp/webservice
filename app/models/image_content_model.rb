#### NOT A REAL MODEL, ONLY TO BE SUBCLASSED!!! ####

# not working for some reason, stack overflow question pending on it

# superclass of all models with common paperclip settings for images
class ImageContentModel < ActiveRecord::Base
  # prevents active admin from
  self.abstract_class = true

  # *** call 'selff.has_attached_file_with_root' in subclasses with unique path start for S3 storage ***

  ### Default home photo attachments ###
  def self.has_attached_file_with_root(root)
    has_attached_file(:image,
                      s3_credentials: {
                        bucket: ENV['AWS_BUCKET_NAME'],
                        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                      },
                      # path: ':rails_root/public/images/simple_events/:style/:basename.:extension',
                      url: "/images/#{root}/:style/:basename.:extension",
                      default_url: '/images/missing.png',
                      path: "images/#{root}/:style/:basename.:extension",
                      styles: {
                        detail: '100X100#',
                        blurred: {
                          size: '640x256',
                          offset: '+0+0',
                          raduis_sigma: '9x4',
                          tint: '40',
                          processors: [:blur]
                        },
                        home: '640X640#'
                      })

    # validates_attachment :image, :content_type => { :content_type => "image/jpeg"}
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
    validates_with AttachmentSizeValidator, attributes: :image, less_than: 5.megabytes
  end
end

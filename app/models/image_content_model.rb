#### NOT A REAL MODEL, ONLY TO BE SUBCLASSED!!! ####

# not working for some reason, stack overflow question pending on it

# superclass of all models with common paperclip settings for images
class ImageContentModel < ActiveRecord::Base
  # model has no database equivalent, so this prevents active admin from trying to access a table for it
  self.abstract_class = true

  # *** call 'self.attach_file_with_root' in subclasses with unique path start for S3 storage ***

  ### Default home photo attachments ###
  def self.attach_file_with_root(root)
    # sets up paperclip model
    has_attached_file(:image,
                      s3_credentials: {
                        bucket: ENV['AWS_BUCKET_NAME'],
                        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                      },
                      url: "/images/#{root}/:style/:basename.:extension",
                      default_url: '/images/missing.png',
                      path: "images/#{root}/:style/:basename.:extension",
                      styles: {
                        detail: '100X100#',
                        blurred: {
                          size: '640x256',
                          offset: '+0+0',
                          raduis_sigma: '12x5',
                          tint: '40',
                          processors: [:blur]
                        },
                        home: '640X640#'
                      })

    # validates_attachment :image, :content_type => { :content_type => "image/jpeg"}
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
    validates_with AttachmentSizeValidator, attributes: :image, less_than: 5.megabytes
  end

  protected

  # breaks asset precompilation for some reason
  def defined_styles
    default_styles = {
      detail: '100X100#',
      blurred: {
        size: '640x256',
        offset: '+0+0',
        raduis_sigma: '12x5',
        tint: '40',
        processors: [:blur]
      },
      home: '640X640#'
    }
    default_styles
  end
end

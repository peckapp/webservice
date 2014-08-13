module Paperclip
  # this class creates a blurred, darkened image for the background of the images
  # in the homepage and explore dropdown of the app
  class Blur < Processor
    # copied in thumbnail processor from paperclip source

    # some default values, may be overridden in the models that use this processor
    DEFAULT_SIZE = '640X256'
    DEFAULT_GRAVITY = 'center'
    OFFSET = '+0+0'
    RADIUS_SIGMA = '9x5'
    TINT_STRENGTH = 40 # range 0-100
    BRIGHTNESS = 100 # range 0 to 200, current is 100
    SATURATION = 110 # range 0 to 200, current is 100

    #   +format+ - the desired filename extension
    #   +animated+ - whether to merge all the layers in the image. Defaults true
    def initialize(file, options = {}, attachment = nil)
      super

      @file                = file
      @whiny               = options.fetch(:whiny, true)
      @format              = options[:format]

      @size                = options[:size] || DEFAULT_SIZE
      @gravity             = options[:gravity] || DEFAULT_GRAVITY
      @offset              = options[:offset] || OFFSET
      @radius_sigma        = options[:radius_sigma] || RADIUS_SIGMA
      @tint                = options[:tint] || TINT_STRENGTH
      @brightness          = options[:brightness] || BRIGHTNESS
      @saturation          = options[:saturation] || SATURATION

      @source_file_options = @source_file_options.split(/\s+/) if @source_file_options.respond_to?(:split)
      @convert_options     = @convert_options.split(/\s+/)     if @convert_options.respond_to?(:split)

      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
    end

    # Returns true if the image is meant to make use of additional convert options.
    def convert_options?
      !@convert_options.nil? && !@convert_options.empty?
    end

    # Performs the conversion of the +file+ into cropped, resized, blurred, darkened image.
    # Returns the Tempfile that contains the new image.
    def make
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode

      begin
        parameters = []
        parameters << ':source'
        parameters << transformation_command
        parameters << ':dest'

        parameters = parameters.flatten.compact.join(' ').strip.squeeze(' ')

        src_path = File.expand_path(src.path)
        dst_path = File.expand_path(dst.path)
        convert(parameters, source: src_path, dest: dst_path)
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "There was an error processing the blurred image for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new('Could not run the `convert` command. Please install ImageMagick.')
      end

      dst
    end

    # Returns the command ImageMagick's +convert+ needs to transform the image
    # into the thumbnail.
    def transformation_command
      # -resize 640x256^ -gravity Center -crop 640x256+0+0 +repage -gaussian-blur 10X6 -normalize -fill black -colorize 40% -modulate 100,110
      trans = []
      trans << '-resize' << %("#{DEFAULT_SIZE}^")
      trans << '-gravity' << %(#{DEFAULT_GRAVITY})
      trans << '-crop' << %("#{DEFAULT_SIZE}#{OFFSET}") << '+repage'
      trans << '+repage'
      trans << '-gaussian-blur' << %("#{RADIUS_SIGMA}")
      trans << '-normalize'
      trans << '-fill' << 'black'
      trans << '-colorize' << %("#{TINT_STRENGTH}%")
      trans << '-modulate' << %("#{BRIGHTNESS},#{SATURATION}")
      trans
    end
  end
end

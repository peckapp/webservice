module Paperclip
  # this class creates a blurred, darkened image for the background of the images
  # in the homepage and explore dropdown of the app
  class BlurProcessor < Processor
    # copied in thumbnail processor from paperclip source

    DEFAULT_SIZE = '640x256'
    RADIUS_SIGMA = '9x5'
    TINT_STRENGTH = 40 # range 0-100
    BRIGHTNESS = 100 # range 0 to 200, current is 100
    SATURATION = 110 # range 0 to 200, current is 100

    #   +format+ - the desired filename extension
    #   +animated+ - whether to merge all the layers in the image. Defaults true
    def initialize(file, options = {}, attachment = nil)
      super

      geometry             = options[:geometry].to_s
      @file                = file
      @target_geometry     = options.fetch(:string_geometry_parser, Geometry).parse(geometry)
      @current_geometry    = options.fetch(:file_geometry_parser, Geometry).from_file(@file)
      @source_file_options = options[:source_file_options]
      @convert_options     = options[:convert_options]
      @whiny               = options.fetch(:whiny, true)
      @format              = options[:format]
      @animated            = options.fetch(:animated, true)
      @auto_orient         = options.fetch(:auto_orient, true)
      if @auto_orient && @current_geometry.respond_to?(:auto_orient)
        @current_geometry.auto_orient
      end

      @source_file_options = @source_file_options.split(/\s+/) if @source_file_options.respond_to?(:split)
      @convert_options     = @convert_options.split(/\s+/)     if @convert_options.respond_to?(:split)

      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
    end

    # Returns true if the image is meant to make use of additional convert options.
    def convert_options?
      !@convert_options.nil? && !@convert_options.empty?
    end

    # Performs the conversion of the +file+ into a thumbnail. Returns the Tempfile
    # that contains the new image.
    def make
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode

      begin
        parameters = []
        parameters << source_file_options
        parameters << ':source'
        parameters << transformation_command
        parameters << ':dest'

        parameters = parameters.flatten.compact.join(' ').strip.squeeze(' ')

        success = convert(parameters, source: "#{File.expand_path(src.path)}#{'[0]' unless animated?}", dest: File.expand_path(dst.path))
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
      # -resize 640x256^ -gravity Center -crop 640x256+0-150 +repage -gaussian-blur 10X6 -normalize -fill black -colorize 40% -modulate 100,110
      trans = []
      trans << '-resize' << %("#{DEFAULT_SIZE}")
      trans << '-crop' << %("#{DEFAULT_SIZE}^") << '+repage'
      trans << '+repage'
      trans << '-gaussian-blur' << %("#{RADIUS_SIGMA}")
      trans << '-normailze'
      trans << '-fill' << 'black'
      trans << '-colorize' << %("#{TINT_STRENGTH}%")
      trans << '-modulate' << %("#{BRIGHTNESS},#{SATURATION}")
      trans
    end
  end
end

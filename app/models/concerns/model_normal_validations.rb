module ModelNormalValidations
  extend ActiveSupport::Concern

  LETTERS_REGEX = /\A[a-zA-Z]+\z/
  # URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*‌​)?$/ix
 # include ActionView::Helpers

  private
    def is_correct_type(parameter, type, type_string_format, symbol)
      # sanitized_parameter = parameter.sanitize(parameter, :tags => %w(b i u))
      unless parameter == nil
        errors.add(symbol, "must be a #{type_string_format}") unless parameter.is_a? type

        # testing. remove later
        errors.full_messages.each do |msg|
          puts msg
        end
      end
    end

  ### Doesn't work since there's a default value ###
  # def is_boolean(parameter, symbol)
  #   errors.add(symbol, "must be a boolean") unless [TrueClass, FalseClass].include?(parameter.class)
  #   errors.full_messages.each do |msg|
  #     puts msg
  #   end
  # end
end

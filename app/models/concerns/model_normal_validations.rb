module ModelNormalValidations
  extend ActiveSupport::Concern

  LETTERS_REGEX = /\A[a-zA-Z]+\z/
  # URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*‌​)?$/ix
  # include ActionView::Helpers

  private
  def is_correct_type(parameter, type, type_string_format, symbol)
    unless parameter.nil?
      errors.add(symbol, "must be a #{type_string_format}") unless parameter.is_a? type
    end
  end
end

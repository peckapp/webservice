module ModelBeforeSaveValidations
  extend ActiveSupport::Concern

  ##### include ActionView::Helpers

  # included do
  #   before_save :check_validity
  #   before_create :check_validity
  #   before_update :check_validity
  # end
  # private

    # before callbacks. If valid, returns true. If invalid, returns false.
    # def check_validity
    #   return self.valid?
    # end
    #
    # def sanitize_everything(attributes_array)
    #   attributes_array.each do |attribute|
    #     attribute.sanitize(attribute, :tags => %w(b i u))
    #   end
    # end

  #### probably won't use everything below
  # def validate_attribute(theAttribute, attribute_string, theType, type_string)
  #   error_messages = []
  #   # theAttribute = theAttribute.sanitize(theAttribute, :tags => %w(b i u))
  #   # string representation of the attributes and types
  #   theAttribute_string = attribute_string
  #   theType_string = type_string
  #   if theAttribute.blank?
  #     error_messages << "#{theAttribute_string} cannot be blank"
  #   end
  #
  #   unless theAttribute.is_a?(theType)
  #     error_messages << "#{theAttribute_string} must be of type #{theType_string}"
  #   end
  #   puts error_messages
  #   return error_messages
  # end
  #
  # def validate_category
  #   validate_attribute(self.category, "category", String, "String")
  # end
  #
  # def validate_circle_id
  #   validate_attribute(self.circle_id, "circle_id", Fixnum, "Fixnum")
  # end
  #
  # def validate_institution_id
  #   validate_attribute(self.institution_id, "institution_id", Fixnum, "Fixnum")
  # end
  #
  # def validate_user_id
  #   validate_attribute(self.user_id, "user_id", Fixnum, "Fixnum")
  # end
end

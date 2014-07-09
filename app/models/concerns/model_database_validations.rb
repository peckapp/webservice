module ModelDatabaseValidations
  extend ActiveSupport::Concern

  # private
  def validate_attribute(theAttribute, attribute_string, theType, type_string)
    error_messages = []
    # string representation of the attributes and types
    theAttribute_string = attribute_string
    theType_string = type_string
    if theAttribute.blank?
      error_messages << "#{theAttribute_string} cannot be blank"
    end

    unless theAttribute.is_a?(theType)
      error_messages << "#{theAttribute_string} must be of type #{theType_string}"
    end
    puts error_messages
    return error_messages
  end

  def validate_category
  end

  def validate_circle_name
    validate_attribute(self.circle_name, "circle_name", String, "String")
  end

  def validate_institution_id
    validate_attribute(self.institution_id, "institution_id", Fixnum, "Fixnum")
  end

  def validate_user_id
    validate_attribute(self.user_id, "user_id", Fixnum, "Fixnum")
  end
end

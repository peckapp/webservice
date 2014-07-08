module ModelDatabaseValidations
  extend ActiveSupport::Concern 
  def validate_attribute(parameter, type)
    error_messages = []
    if self.parameter.blank?
      error_messages << "#{attribute} cannot be blank"
    end

    unless self.parameter.is_a?(type)
      error_messages << "#{attribute} must be of type #{type}"
    end
    puts error_messages
    return error_messages
  end
end

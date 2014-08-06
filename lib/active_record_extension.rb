# these extensions are intended to make it easy to determine whether or not something exists in the database already
# by either using a specified hash of the interested parameters and their values in the current object
# that can be sent to the database as a query

# A variety of methods are included to prevent duplicate entries in the database during scraping,
# allowing jobs with side effects to remain idempotent
module ActiveRecordExtension
  # extends the active support concerns in order to enable direct calls on model objects
  extend ActiveSupport::Concern

  # add instance methods here
  def model_match_exists(*attrs)
    attrs = attrs.extract_options!
    if attrs.blank?
      # use all non-blank fields in object as parameters
      self.class.columns.each do |c|
        val = self.read_attribute(c.name)
        attrs.merge!(c.name => val) unless val.blank?
      end
    end
    # checks database for the object's existence
    if self.class.exists?(attrs)
      return true
    else
      return false
    end
  end

  # saves only if an instance of the object with matching attributes cannot be found in the database
  # returns false if duplicate exists or the save actually failed due to validations
  def non_duplicative_save(*attrs)
    if !model_match_exists(attrs)
      return save
    else
      return false
    end
  end

  # add your static(class) methods here
  module ClassMethods
    # returns an object matching specified attributes, or creates one with them if none exist
    def current_or_create_new(*attrs)
      if superclass == ActiveRecord::Base
        attrs = attrs.extract_options!

        result = where(attrs).first

        if result.blank?
          return create(attrs)
        else
          return result
        end

      else
        fail "attempted to perform model interaction with inapplicable class: #{model.class}"
      end
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)

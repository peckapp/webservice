# these extensions are intended to make it easy to determine whether or not something exists in the database already
# by either using a specified hash of the interested parameters and their values in the current object
# that can be sent to the database as a query

# A variety of methods are included to prevent duplicate entries in the database during scraping

module ActiveRecordExtension

  extend ActiveSupport::Concern

  # add instance methods here
  def model_match_exists(*attrs)
    # method only applies to subclass models of the rails ActiveRecord::Base class
    #if self.class == ActiveRecord::Base
      attrs = attrs.extract_options!
      if attrs.blank?
        # use all non-blank fields in object as parameters
        # puts self.class.instance_methods
        self.class.columns.each { |c|

          val = self.read_attribute(c.name)
          if ! val.blank? then attrs.merge!(c.name => val) end
        }
      end
      # checks database for the object's existence
      if self.class.exists?(attrs)
        return true
      else
        return false
      end
    # else
    #   raise "Attempted to find a model match for type #{self.class} other than an ActiveRecord::Base subclass"
    # end
  end

  # saves only if an instance of the object with matching attributes cannot be found in the database
  def non_duplicative_save(*attrs)
    if ! self.model_match_exists(attrs)
      self.save
      return true
    else
      return false
    end
  end

  # add your static(class) methods here
  module ClassMethods

    # returns an object matching specified attributes, or creates one with them if none exist
    def current_or_create_new(*attrs)

      if self.superclass == ActiveRecord::Base
        attrs = attrs.extract_options!

        result = self.where(attrs).first

        if result.blank?
          puts "attrs: #{attrs}"
          return self.create(attrs)
        else
          return result
        end

      else
        raise "attempted to perform model interaction with inapplicable class: #{model.class}"
      end
    end

  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)

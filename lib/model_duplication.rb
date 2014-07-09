# this class is intended to make it east to determine whether or not something exists in the database already
# by either using a specified hash of the interested parameters and their values in the current object
# that can be sent to the database as a query


class ModelDuplication

  attr_accessor :attributes

  def initialize

  end

  def self.model_match_exists(object, *attrs)
    # method only applies to subclass models of the rails ActiveRecord::Base class
    if object.class.superclass == ActiveRecord::Base
      attrs = attrs.extract_options!
      if attrs.blank?
        # use all non-blank fields in object as parameters
        object.class.columns.each { |c|
          val = object[c.name]
          if ! val.blank? then attrs.merge!(c.name => val) end
        }
      end
      # checks database for the object's existence
      if object.class.exists?(attrs)
        return true
      else
        return false
      end
    else
      raise "Attempted to find a model match for type other than an ActiveRecord::Base subclass"
    end
  end

  # saves only if an instance of the object with matching attributes cannot be found in the database
  def self.non_duplicative_save(object, *attrs)
    begin
      if ! self.model_match_exists(object, attrs[0])
        object.save
        return true
      else
        return false
      end
    rescue
      puts "error rescued in non_duplicative_save"
    end

  end

  # returns an object matching specified attributes, or creates one with them if none exist
  def self.current_or_create_new(class, *attrs)

    if object.class.superclass == ActiveRecord::Base
      attrs = attrs.extract_options!

      result = class.where(attrs)

      if result.blank?
        return class.create(attrs)
      else
        return result
      end

    else
      raise "attempted to perform model interaction with inapplicable class"
    end
  end

end

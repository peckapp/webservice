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
      puts "attrs: #{attrs} are blank? #{attrs.blank?}"
      if attrs.blank?
        # use all non-blank fields in object as parameters
        puts "filling in options for the search"
        object.class.columns.each { |c|
          val = object[c.name]
          if ! val.blank? then attrs.merge!(c.name => val) end
        }
      end
      # checks database for the object's existence
      if ! object.class.exists?(attrs)
        puts "an object with the parameters: #{attrs} already exists"
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.non_duplicative_save(object, *attrs)
    # method only applies to subclass models of the rails ActiveRecord::Base class
    #puts "initial attrs: #{attrs.extract_options!}"

    if ! self.model_match_exists(object, attrs[0])
      puts "***** saving object *****"
      object.save
      return true
    else
      return false
    end

  end

end

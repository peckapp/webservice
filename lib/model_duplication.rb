# this class is intended to make it east to determine whether or not something exists in the database already
# by either using a specified hash of the interested parameters and their values in the current object
# that can be sent to the database as a query

module ModelDupliation

  def initialize

  end

  def self.model_match_exists(object, hash)
    # method only applies to subclass models of the rails ActiveRecord::Base class
    if object.class.superclass == ActiveRecord::Base
      if ! object.class.exists?(hash)
        return true
      else
        return false
      end
    end
    false
  end

  def self.non_duplicative_save(object, hash)
    # method only applies to subclass models of the rails ActiveRecord::Base class

    if ! self.model_match_exists(object,hash)
      object.save
      return true
    else
      return false
    end

  end

end

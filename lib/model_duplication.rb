class ModelDupliation

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
    else
      # do nothing
    end

  end

end

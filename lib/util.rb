#various utilities for the rails app

class Util


  # don't care about the error thrown here, will return nil is Object isn't found
  def self.class_from_string(str)
    begin
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end

end

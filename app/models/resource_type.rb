# this class is an index of the resource types for the set of scrape resources

class ResourceType < ActiveRecord::Base
  ### Each ScrapeResource has a specificed resource type that relates it to a specific model
  has_many :scrape_resources

  ### Each DataResource has a specified resoutce type from which it infers the model that it relates to
  has_many :data_resources

  def model
    Util.class_from_string(model_name)
  end
end

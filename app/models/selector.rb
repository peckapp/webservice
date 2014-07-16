class Selector < ActiveRecord::Base

  has_many :scrape_resources

  ### Each Data Resource indicates which column the object is associated with, or if it is a top-level model
  has_many :data_resources

  ### Selectors can be nested through references to parent selectors that contain them
  # this relates directly to the html parsing that will occur during scraping
  has_many :selectors

  # inferred model for this selector
  def model
    return DataResource.find(data_resource_id).model
  end

  def children
    Selector.find(parent_selector_id: parent_selector_id)
  end

  def column_name
    Data_Resource.find(data_resource_id).column_name
  end

end

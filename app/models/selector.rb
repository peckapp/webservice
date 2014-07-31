class Selector < ActiveRecord::Base
  validates_associated :scrape_resources
  validates_associated :data_resources
  # validates that parent_selector_id must be nil for top level opbjects
  validate do |selector|
    if top_level && !parent_selector_id.blank?
      selector.errors[:base] << "top_level selectors must have nil parent_selector_id's"
    end
  end

  has_many :scrape_resources

  ### Each Data Resource indicates which column the object is associated with, or if it is a top-level model
  has_many :data_resources

  ### Selectors can be nested through references to parent selectors that contain them
  # this relates directly to the html parsing that will occur during scraping
  has_many :selectors

  # inferred model for this selector
  def model
    DataResource.find(data_resource_id).model
  end

  def parent
    Selector.find(parent_selector_id)
  end

  def children
    Selector.where(parent_selector_id: id)
  end

  def column_name
    DataResource.find(data_resource_id).column_name
  end
end

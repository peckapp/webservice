class Selector < ActiveRecord::Base
  validates_associated :scrape_resource
  validates_associated :data_resource
  # validates that parent_id must be nil for top level opbjects
  validate do |selector|
    if top_level && !parent_id.blank?
      selector.errors[:base] << "top_level selectors must have nil parent_id's"
    end
  end

  ### Each selector belongs to a scrape resource that directly owns it
  belongs_to :scrape_resource

  ### Each Data Resource indicates which column the object is associated with, or if it is a top-level model
  belongs_to :data_resource

  ### Selectors can be nested through references to parent selectors that contain them
  # this relates directly to the html parsing that will occur during scraping
  has_many :children, class_name: 'Selector', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Selector'

  accepts_nested_attributes_for :children

  # inferred model for this selector
  def model
    ScrapeResource.find(scrape_resource_id).model
  end

  def column_name
    DataResource.find(data_resource_id).column_name
  end

  def to_label
    info
  end
end

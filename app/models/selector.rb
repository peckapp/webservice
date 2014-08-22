# css selectors indicating specific parts of a webpage
# follow a nested structure with parent selectors that refer to child selectors
# parent selectors contain a block of html
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

  ### Each Selector may have a foreign key as its main DataResource
  ### thus necessitaiting this key, which allows the scraper to convert the text relating
  ### to a row in another table into an actual integer value (key) relating to that row
  belongs_to :foreign_data_resource, foreign_key: :foreign_data_resource_id, class_name: 'DataResource'

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

  def foreign_key?
    DataResource.find(data_resource_id).foreign_key if data_resource_id
  end

  def display_name
    info
  end
end

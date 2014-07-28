# scraped the williams daily dining menus from the CSV file provided by OIT
# a more robust version should be written that appropriately handles the actual interface using sleinium

require 'csv'

class WilliamsDiningWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(2) }
  # recurrence { minutely }

  def perform
    column = "name"
    search = "Williams"
    inst = Institution.where("? LIKE ?", "#{column}", "%#{search}%").first
    # 
    inst_id = 1
    inst_id = inst.id unless inst.blank?

    if true # resources.blank?
      #williams = Institution.where(name: "Williams")
      scrape_csv_page("http://dining.williams.edu/files/daily-menu.csv", inst_id)
    else
      resources.each do |r|
        scrape_csv_page(r.url, r.institution_id)
      end
    end
  end


  def scrape_csv_page(url, inst_id)

    puts "scraping csv page at url: #{url} for inst_id: #{inst_id}"

    file = RestClient.get(url)

    csv = CSV.parse(file)

    csv.each do |l|

      mi = MenuItem.new(institution_id: inst_id, details_link: url)

      puts "==> #{l}"

      # indicies within csv lines are specific to the williams resources
      mi.name = l[2]

      mi.category = l[1]

      mi.serving_size = l[4]

      mi.date_available = Date.current

      # find the corresponding keys for the place and opportunity
      place = DiningPlace.current_or_create_new(name: l[0], institution_id: inst_id)
      mi.dining_place_id = place.id

      opportunity = DiningOpportunity.current_or_create_new(dining_opportunity_type: l[3], institution_id: inst_id)
      mi.dining_opportunity_id = opportunity.id

      # saves the new menu_item into the database
      result = mi.non_duplicative_save
      puts result
    end

  end

end

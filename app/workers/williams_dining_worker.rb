class WilliamsDiningWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # recurrence { daily.hour_of_day(2) }
  recurrence { minutely }

  def perform
    resources = Tasks::ScrapeResource.where(resource_type: "dining_csv", validated: true)
    if resources.blank?
      williams = Institution.where(name: "Williams")
      scrape_csv_page("http://dining.williams.edu/files/daily-menu.csv", williams.id)
    else
      resources.each do |r|
        scrape_csv_page(r.url, r.institution_id)
      end
    end
  end

  private

    def scrape_csv_page(url, inst_id)

      file = RestClient.get(url)

      csv = CSV.parse(file)

      mi = MenuItem.new(institution_id: inst_id, details_link: url)

      csv.each do |l|

        puts "==> #{l}"

        # indicies within csv lines are specific to the williams resources
        mi.name = l[2]

        mi.category = l[1]

        mi.serving_size = l[4]

        # find the corresponding keys for the place and opportunity
        place = ModelDuplication.current_or_create_new(DiningPlace, name: l[0], institution_id: inst_id)
        mi.dining_place_id = place.id

        opportunity = ModelDuplication.current_or_save_new(DiningOpportunity, name: l[3], institution_id: inst_id)
        mi.dining_opportunity_id = opportunity.id
      end

      mi.save

    end

end

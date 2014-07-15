# scrapes middlebury's dining menus
class MiddleburyDiningWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(2) }

  MIDD_MENUS = "http://menus.middlebury.edu"
  DATE_FORMAT = "%A, %B %-d, %Y"

  def perform
    midd_id = Institution.where(name: 'Middlebury').id
    resources = Tasks::ScrapeResource.where(resource_type: "dining", validated: true, institution_id: midd_id)
    if resources.blank?
      resources << Tasks::ScrapeResource.current_or_create_new(url: MIDD_MENUS, institution_id: midd_id)
    else
      resources.each do |r|
        b = Watir::Browser.new
        b.goto MIDD_MENUS
        puts 'entering loop'
        self.menu_loop(b)
      end
    end
  end

  def scrape_forward(b)
    (0..5).each do |increment|

      puts "#{increment} days from now"

      date = Date.current + increment
      date_str = date.strftime(MIDD_DATE_FORMAT)
      date_field = b.text_field name: 'field_day_value[value][date]'
      date_field.set date_str

      apply_button = b.button id: 'edit-submit-menus-test'
      apply_button.click

      data = b.div :class => 'view view-menus-test view-id-menus_test view-display-id-page'

      if data.exists?
        html_raw = data.html
        scrape_html(data.html.squish, date)
      else
        # log that data cannot be found, notify logs of a serious error with the scraping
        # eventually, trigger the analysis phase of the webpage once again
      end

      sleep 1 + rand

    end
  end

  def scrape_html(html_raw, date)
  html = Nokogiri::HTML(html_raw)

  html.css("table[class*='views-view-grid']").each do |table|

    place = table.previous.previous.text

    table.css('td').each do |entry|
      opportunity_type = entry.css('span[class=field-content]').text

      entry.css('p').children.each do |item|
        if ! item.text.blank?

          item_name = item.text

          mi = {item_name: item_name, opportunity_type: opportunity_type, place: place, date: date}

          puts mi

        end # end if
      end # end entry items

    end # end table entries

  end # end tables

end

end

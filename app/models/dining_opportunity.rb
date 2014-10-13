class DiningOpportunity < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # home institution for this dining opportunity #
  belongs_to :institution #

  # opportunities for these dining periods #
  has_many :dining_periods #

  # dining places #
  has_and_belongs_to_many :dining_places, join_table: :dining_opportunities_dining_places #

  # available menu items #
  has_many :menu_items #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :dining_opportunity_type, presence: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_dining_opportunity_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  def id_for_wday(wday)
    id * (Util.date_time_for_week_day(wday).to_i % 10_000)
  end

  def display_name
    dining_opportunity_type
  end

  # who even uses actual numbers in ruby tho?

  # returns an array of triples each containing a dining opp with a start and end time given the day of week
  def self.earliest_start_latest_end(day_of_week, inst_id)
    # get all dining opps and their times for a certain day of the week
    all_times_for_opps = DiningPeriod.where(day_of_week: (day_of_week % 7), institution_id: inst_id).pluck(:dining_opportunity_id, :start_date, :end_date)

    # hash associating opps to an array of its earliest start and latest end
    early_and_late_for_opps = {}

    # earliest and latest times so far given dining opportunity
    earliest_so_far = {}
    latest_so_far = {}

    all_times_for_opps.each do |opp|

      opp_id = opp[0]
      start_date = Util.date_time_for_week_day(day_of_week, opp[1])
      end_date = Util.date_time_for_week_day(day_of_week, opp[2])

      # initializes opp_id value if nil or changes both earliest and latest
      if early_and_late_for_opps[opp_id].nil? || (start_date < earliest_so_far[opp_id] && end_date > latest_so_far[opp_id])
        early_and_late_for_opps[opp_id] = [start_date, end_date]
        earliest_so_far[opp_id] = start_date
        latest_so_far[opp_id] = end_date

      elsif start_date < earliest_so_far[opp_id] # updates just the start time

        early_and_late_for_opps[opp_id][0] = start_date

      elsif end_date > latest_so_far[opp_id] # updates just the end time

        early_and_late_for_opps[opp_id][1] = end_date

      end
    end

    # adjust day for end time if the opportunity extends beyond midnight
    early_and_late_for_opps.each do |opp|
      early = opp[1][0]
      late = opp[1][1]

      late += 1.days if early.hour > late.hour if !early.blank? && !late.blank?

      early_and_late_for_opps[opp[0]][1] = late
    end

    early_and_late_for_opps
  end

  private

  def correct_dining_opportunity_types
    is_correct_type(dining_opportunity_type, String, 'string', :dining_opportunity_type)
  end
end

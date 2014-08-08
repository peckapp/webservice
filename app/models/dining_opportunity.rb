class DiningOpportunity < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

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

  def to_label
    dining_opportunity_type
  end

  # returns an array of triples each containing a dining opp with a start and end time given the day of week
  def self.earliest_start_latest_end(day_of_week)

    # get all dining opps and their times for a certain day of the week
    all_times_for_opps = DiningPeriod.where(:day_of_week => day_of_week).pluck(:dining_opportunity_id, :start_time, :end_time)

    # hash associating opps to an array of its earliest start and latest end
    early_and_late_for_opps = {}

    # earliest and latest times so far given dining opportunity
    earliest_so_far = {}
    latest_so_far = {}

    for opp in all_times_for_opps

      opp_id = opp[0]
      start_time = Util.date_time_for_week_day(day_of_week, opp[1])
      end_time = Util.date_time_for_week_day(day_of_week, opp[2])

      if early_and_late_for_opps[opp_id] == nil || (start_time < earliest_so_far[opp_id] && end_time > latest_so_far[opp_id])

        early_and_late_for_opps[opp_id] = [start_time, end_time]
        earliest_so_far[opp_id] = start_time
        latest_so_far[opp_id] = end_time

      elsif start_time < earliest_so_far[opp_id]

        early_and_late_for_opps[opp_id][0] = start_time

      elsif end_time > latest_so_far[opp_id]

        early_and_late_for_opps[opp_id][1] = end_time

      end
    end

    for opp in early_and_late_for_opps

      early = opp[1][0]
      late = opp[1][1]

      if !early.blank? && !late.blank?
        if early.hour > late.hour
          late = late + 1.days
        end
      end

      early_and_late_for_opps[opp[0]][1] = late

    end

    early_and_late_for_opps
  end

  private

    def correct_dining_opportunity_types
      is_correct_type(dining_opportunity_type, String, 'string', :dining_opportunity_type)
    end
end

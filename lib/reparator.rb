# provides utilities for reqairing improperly formatted or incomplete scraped models
module Reparator
  # hands model to its specific repair method
  def self.repair_model(model)
    logger.warn "INITIALLY invalid model #{model.class} after scraping: #{model.errors.messages}"

    # attempt to fix certain validation errors
    if model.class == SimpleEvent
      repair_simple_event(model)
    elsif model.class ==  AthleticEvent
      repair_athletic_event(model)
    elsif model.class ==  AthleticTeam
      repair_athletic_team(model)
    else
      logger.info "Attempted to repair model of class #{model.class} without a handler"
      # handle other types as they come up building the scraping
    end
  end

  protected

  def self.repair_simple_event(event)
    # logger.info 'repairing simple event'
    err = event.errors.messages
    if err.keys.include? :end_date
      logger.warn 'setting length of event without end date arbitarily to 1 hour'
      # set a default event length of 1 hour
      event.end_date = event.start_date + 1.hours if event.start_date
    else
      # handle other possible errors
    end
  end

  def self.repair_athletic_event(event)
    # logger.info 'repairing athletic event'
    event.errors.messages.keys.each do |key|
      case key
      when :location
        # logger.warn "Arbitrarily assigning 'Williams College' as athletic event location"
        event.location = 'Williams College'
      when :end_time
        # logger.warn "Arbitrarily assigning end_time to a length of 1 hour"
        event.end_time = event.start_time + 1.hours
      else
        logger.error "repair_athletic_event failed to handle key: #{key}"
      end
    end
  end

  def self.repair_athletic_team(team)
    # logger.info 'repairing athletic team'
    team.errors.messages.keys.each do |key|
      case key
      when :sport_name
        # could use some work, may not apply to every case
        sport = team.simple_name.match(/ .*/).to_s.squish
        team.sport_name = sport
      when :gender
        gender = team.simple_name.match(/(M|m)en|(W|w)omen/).to_s
        team.gender = gender
      else
        logger.error "repair_athletic_team failed to handle key: #{key}"
      end
    end
    logger.info
  end
end

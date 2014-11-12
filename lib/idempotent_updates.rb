# contains methods for saving and updating existing records
module IdempotentUpdates
  STANDARD_COLUMNS = %w(id created_at updated_at image_file_name image_content_type image_file_size image_updated_at)

  #############################################
  ###  Final validations to scraped models  ###
  #############################################

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # if model is invalid using built-in validations, attempt to repair it
    Reparator.repair_model(new_model, logger) unless new_model.valid?

    # clear errors to retry validations after attempted fixes
    new_model.errors.clear
    # perform save
    if new_model.valid?
      idempotent_save_or_update(new_model)
    else
      # logger.info new_model.start_date.class
      logger.warn "failed to save model with errors #{new_model.errors.messages}\ntitle: #{new_model.title}\nurl: #{new_model.url}"
    end
    false
  end

  def idempotent_save_or_update(new_model)
    crucial_params = model_crucial_params(new_model)
    match_params = model_match_params(new_model)

    return if exact_match?(new_model, crucial_params, match_params)

    match = closest_match(new_model, crucial_params, match_params)
    # logger.info "closest_match: #{match.inspect}"

    # either a complete match was found, or no match was found at all
    return update_matching_model(match, new_model) if match

    # default relying on solely non-duplicative save
    default_save(new_model)
  end

  # updates the found match with the parameters in the new model that are more current
  def update_matching_model(match, new_model)
    changed = 0
    new_model.class.column_names.each do |k|
      next if (new_model[k] == match[k]) || STANDARD_COLUMNS.include?(k) # nothing to do or column should remain same
      changed += 1
      # logger.info "XXX #{k} XXX old: #{match[k]} => new: #{new_model[k]}" if new_model[k] != match[k]
      match.update_attributes(k => new_model[k])
    end
    logger.info "Updated matching model of type '#{match.class}' of id: #{match.id} with #{changed} modified fields"
    match.save
  end

  # executes the default saving behavior with only simple exect duplicate protection
  def default_save(new_model)
    if new_model.non_duplicative_save
      logger.info "Saved validated model of type '#{new_model.class}' with id: #{new_model.id}\n"
      return true
    else
      logger.info "Validated model of type '#{new_model.class}' already existed and was not saved"
    end
  end

  #########################################
  ###  Finding matches in the Database  ###
  #########################################

  # determines whether or not an exact match exists for the found parameters
  def exact_match?(new_model, crucial_params, match_params)
    all_params = crucial_params.merge(match_params)
    # logger.info "all_params: #{all_params}"
    matches = new_model.class.where(all_params)
    return false unless matches.any?
    if matches.count > 1
      logger.warn 'Multiple exact matches found for the scraped new model. Something is wrong'
      logger.info "#{matches.count} matches found for #{new_model.class} with params #{all_params}"
    end
    if new_model.class == SimpleEvent
      logger.info "exact match found for params #{all_params.keys}, moving to next item"
    end
    true
  end

  # uses match parameters until a singluar match is found
  def closest_match(new_model, crucial_params, match_params)
    best_matches = []
    # for an increasing number of parameters, look for matches with all combinations of that number of match params
    # looks for the match fitting the highest number of parameters and chooses that one
    # TODO: can be optimized since certain possibilities can be nipped out of future iterations if their descendants did not have matches
    1.upto(match_params.count - 1) do |count|
      match_found = false
      CombinatorialIterator.new(count, match_params).mapCombinations do |params|
        cur_params = crucial_params.merge(params)
        matches = new_model.class.where(cur_params)
        # logger.info "found #{matches.count} matches for cur_params: #{cur_params.keys}"
        if matches.any?
          match_found = true
          # logger.info "new_model: #{new_model.inspect}\nmatch: #{matches.first.inspect}"
          best_matches = matches
        end
      end
      break unless match_found # stop the iteration is no matches were found for this humber of parameters
    end
    best_matches.first
  end

  # return the params defined in the models that indicate which fields are crucial to match exactly, and which are flexible
  def model_crucial_params(new_model)
    logger.error "CRUCIAL_ATTRS undefined for model #{new_model.class}" unless defined? new_model.class::CRUCIAL_ATTRS
    Hash[new_model.class::CRUCIAL_ATTRS.map { |a| [a, new_model[a]] }]
  end

  def model_match_params(new_model)
    logger.error "MATCH_ATTRS undefined for model #{new_model.class}" unless defined? new_model.class::MATCH_ATTRS
    Hash[new_model.class::MATCH_ATTRS.map { |a| [a, new_model[a]] }]
  end
end

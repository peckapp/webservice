child :@explore_events do
  attributes :id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :url, :public,
             :comment_count, :start_date, :end_date, :created_at, :updated_at

  # node :position do |event|
  #   @event_positions[event.id]
  # end

  node(:event_type) { 'simple' }

  node :image do |simple_event|
    simple_event.image.url(:home)
  end

  node :blurred_image do |simple_event|
    simple_event.image.url(:blurred)
  end

  node :likes do |explore_event|
    @likes_for_explore_events[explore_event.id]
  end

  node :score do |explore_event|
    @simple_explore_scores[explore_event.id]
  end
end

child :@explore_announcements do
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :category, :poster_id, :public,
             :comment_count, :created_at, :updated_at

  node :image do |announcement|
    announcement.image.url(:home)
  end

  node :likes do |explore_announcement|
    @likes_for_explore_announcements[explore_announcement.id]
  end

  node :score do |explore_announcement|
    @announcement_explore_scores[explore_announcement.id]
  end
end

child :@explore_athletics do
  attributes :id, :institution_id, :athletic_team_id, :opponent, :team_score, :opponent_score, :home_or_away,
             :location, :result, :note, :start_date, :end_date, :title, :description, :created_at, :updated_at

  # node :image do |explore_ath_event|
  #   explore_ath_event.image.url
  # end

  node :image do |athletic_event|
    athletic_event.backed_image.url(:home)
  end

  node :likes do |explore_ath_event|
    @likes_for_explore_athletics[explore_ath_event.id]
  end

  node :score do |explore_ath_event|
    @athletic_explore_scores[explore_ath_event.id]
  end
end

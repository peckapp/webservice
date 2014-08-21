child :@explore_events do
# collection :@explore_events

  attributes :id, :title, :event_description, :institution_id, :user_id, :category, :organizer_id, :url, :public, :comment_count, :start_date, :end_date, :created_at, :updated_at

  # node :position do |event|
  #   @event_positions[event.id]
  # end

  node(:event_type) { 'simple' }

  node :image do |simple_event|
    simple_event.image.url
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
  attributes :id, :title, :announcement_description, :institution_id, :user_id, :category, :poster_id, :public, :comment_count, :created_at, :updated_at

  # node :position do |announcement|
  #   @announcement_positions[announcement.id]
  # end

  node :image do |announcement|
    announcement.image.url
  end

  node :likes do |explore_announcement|
    @likes_for_explore_announcements[explore_announcement.id]
  end

  node :score do |explore_announcement|
    @announcement_explore_scores[explore_announcement.id]
  end
end

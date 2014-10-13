namespace :db do
  desc 'Erase and fill database'
  task populate: :environment do
    require 'populator'
    require 'faker'

    content_models = [User, Subscription, Circle, CircleMember, Department,
                      Club, AthleticTeam, SimpleEvent, Comment, EventAttendee,
                      View, Like, Announcement, AthleticEvent]

    content_models.each(&:delete_all)

    User.populate 500 do |user|
      user.institution_id = 1
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.email = Faker::Internet.email
      user.blurb = Populator.sentences(1..3)
      user.created_at = 2.years.ago..Time.now

      Subscription.populate 15..40 do |subscription|
        subscription.user_id = user.id
        subscription.category = %w(athletic club department)
        subscription.subscribed_to = 1..50
        subscription.created_at = 2.years.ago..Time.now
        subscription.institution_id = 1
      end
    end

    Department.populate 50 do |dept|
      dept.name = Faker::Commerce.department
      dept.institution_id = 1
      dept.created_at = 2.years.ago..Time.now
    end

    Club.populate 50 do |club|
      club.institution_id = 1
      club.club_name = Faker::Company.name
      club.description = Populator.sentences(1..5)
      club.user_id = 1..500
      club.created_at = 2.years.ago..Time.now
    end

    AthleticTeam.populate 25 do |team|
      team.institution_id = 1
      team.sport_name = Populator.words(1).titleize
      team.gender = 'women'
      team.head_coach = Faker::Name.name
      team.created_at = 2.years.ago..Time.now
    end

    AthleticTeam.populate 25 do |team|
      team.institution_id = 1
      team.sport_name = Populator.words(1).titleize
      team.gender = 'men'
      team.head_coach = Faker::Name.name
      team.created_at = 2.years.ago..Time.now
    end

    Circle.populate 100 do |circle|
      circle.institution_id = 1
      circle.circle_name = Faker::Company.name
      circle.created_at = 2.years.ago..Time.now
      circle.user_id = 1..500

      CircleMember.populate 2..20 do |cm|
        cm.institution_id = 1
        cm.circle_id = circle.id
        cm.user_id = 1..500
        cm.invited_by = 1..500
        cm.date_added = 2.years.ago..Time.now
        cm.created_at = 2.years.ago..Time.now
        cm.accepted = true
      end
    end

    ###############################
    ##                           ##
    ##       SIMPLE EVENTS       ##
    ##                           ##
    ###############################

    SimpleEvent.populate 20 do |event|
      event.title = Faker::Commerce.product_name
      event.event_description = Populator.sentences(1..3)
      event.institution_id = 1
      event.user_id = 1..500
      event.category = %w(club department)
      event.organizer_id = 1..50
      event.created_at = 3.days.ago..Time.now
      event.start_date = Time.now..1.month.from_now
      event.end_date = event.start_date + 2.hours

      # simple event has many comments
      c_count = 0 # comment count
      Comment.populate 2..20 do |comment|
        c_count += 1
        comment.category = 'simple'
        comment.comment_from = event.id
        comment.user_id = 1..500
        comment.content = Populator.sentences(1..3)
        comment.institution_id = 1
        comment.created_at = event.created_at..Time.now
      end

      event.comment_count = c_count

      # simple event has many attendees
      ea_count = 0
      EventAttendee.populate 5..50 do |ea|
        ea_count += 1
        ea.user_id = 1..500
        ea.added_by = event.user_id
        ea.category = 'simple'
        ea.event_attended = event.id
        ea.created_at = event.created_at..Time.now
        ea.institution_id = 1

        # create one event view per attendee
        View.populate 1 do |view|
          view.user_id = ea.user_id
          view.category = 'simple'
          view.content_id = event.id
          view.date_viewed = ea.created_at
          view.created_at = ea.created_at
          view.institution_id = 1
        end
      end

      # simple event has many event views
      max_count = 2 * ea_count
      View.populate 5..max_count do |ev|
        ev.user_id = 1..500
        ev.category = 'simple'
        ev.content_id = event.id
        ev.date_viewed = event.created_at..Time.now
        ev.created_at = event.created_at..Time.now
        ev.institution_id = 1
      end

      # simple event has many likes
      Like.populate 5..ea_count do |like|
        like.liker_type = 'User'
        like.liker_id = 1..500
        like.likeable_type = 'SimpleEvent'
        like.likeable_id = event.id
        like.created_at = event.created_at..Time.now
      end

    end

    ###############################
    ##                           ##
    ##       ANNOUNCEMENTS       ##
    ##                           ##
    ###############################

    Announcement.populate 15 do |ann|
      ann.title = Faker::Commerce.product_name
      ann.announcement_description = Populator.sentences(1..3)
      ann.institution_id = 1
      ann.user_id = 1..500
      ann.public = true
      ann.category = %w(club department)
      ann.poster_id = 1..50
      ann.created_at = 1.month.ago..Time.now

      # simple event has many comments
      c_count = 0 # comment count
      Comment.populate 2..20 do |comment|
        c_count += 1
        comment.category = 'announcement'
        comment.comment_from = ann.id
        comment.user_id = 1..500
        comment.content = Populator.sentences(1..3)
        comment.institution_id = 1
        comment.created_at = ann.created_at..Time.now
      end

      ann.comment_count = c_count

      # simple event has many event views
      ev_count = 0
      View.populate 5..100 do |ev|
        ev_count += 1
        ev.user_id = 1..500
        ev.category = 'announcement'
        ev.content_id = ann.id
        ev.date_viewed = ann.created_at..Time.now
        ev.created_at = ann.created_at..Time.now
        ev.institution_id = 1
      end

      # simple event has many likes
      Like.populate 5..ev_count do |like|
        like.liker_type = 'User'
        like.liker_id = 1..500
        like.likeable_type = 'Announcement'
        like.likeable_id = ann.id
        like.created_at = ann.created_at..Time.now
      end

    end

    ###############################
    ##                           ##
    ##      ATHLETIC EVENTS      ##
    ##                           ##
    ###############################

    AthleticEvent.populate 30 do |ae|
      ae.institution_id = 1
      ae.athletic_team_id = 1..50
      ae.opponent = Faker::Company.name
      ae.team_score = 0..10
      ae.opponent_score = 0..10
      ae.home_or_away = %w(home away)
      ae.location = Faker::Address.street_name
      ae.start_date = Time.now..1.month.from_now
      ae.created_at = 1.month.ago..Time.now

      # simple event has many comments
      c_count = 0 # comment count
      Comment.populate 2..20 do |comment|
        c_count += 1
        comment.category = 'athletic'
        comment.comment_from = ae.id
        comment.user_id = 1..500
        comment.content = Populator.sentences(1..3)
        comment.institution_id = 1
        comment.created_at = ae.created_at..Time.now
      end

      # simple event has many attendees
      ea_count = 0
      EventAttendee.populate 5..50 do |ea|
        ea_count += 1
        ea.user_id = 1..500
        ea.added_by = ea.user_id
        ea.category = 'athletic'
        ea.event_attended = ae.id
        ea.created_at = ae.created_at..Time.now
        ea.institution_id = 1

        # create one event view per attendee
        View.populate 1 do |view|
          view.user_id = ea.user_id
          view.category = 'athletic'
          view.content_id = ae.id
          view.date_viewed = ea.created_at
          view.created_at = ea.created_at
          view.institution_id = 1
        end
      end

      # simple event has many event views
      max_count = 2 * ea_count
      View.populate 5..max_count do |ev|
        ev.user_id = 1..500
        ev.category = 'athletic'
        ev.content_id = ae.id
        ev.date_viewed = ae.created_at..Time.now
        ev.created_at = ae.created_at..Time.now
        ev.institution_id = 1
      end

      # simple event has many likes
      Like.populate 5..ea_count do |like|
        like.liker_type = 'User'
        like.liker_id = 1..500
        like.likeable_type = 'AthleticEvent'
        like.likeable_id = ae.id
        like.created_at = ae.created_at..Time.now
      end

    end
  end
end

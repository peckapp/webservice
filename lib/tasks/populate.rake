namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [User, Subscription, Circle, CircleMember, Department, Club, AthleticTeam, SimpleEvent, Comment, EventAttendee, EventView, Like].each(&:delete_all)

    User.populate 2000 do |user|
      user.institution_id = 1
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.email = Faker::Internet.email
      user.blurb = Populator.sentences(1..3)
      user.created_at = 2.years.ago..Time.now

      Subscription.populate 15..40 do |subscription|
        subscription.user_id = user.id
        subscription.category = ["athletic", "club", "department"]
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
      team.gender = "women"
      team.head_coach = Faker::Name.name
      team.created_at = 2.years.ago..Time.now
    end

    AthleticTeam.populate 25 do |team|
      team.institution_id = 1
      team.sport_name = Populator.words(1).titleize
      team.gender = "men"
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

    SimpleEvent.populate 1000 do |event|
      event.title = Faker::Commerce.product_name
      event.event_description = Populator.sentences(1..3)
      event.institution_id = 1
      event.user_id = 1..500
      event.category = ["club", "department"]
      event.organizer_id = 1..50
      event.created_at = 3.days.ago..Time.now
      event.start_date = Time.now..1.month.from_now
      event.end_date = event.start_date + 2.hours

      # simple event has many comments
      c_count = 0 # comment count
      Comment.populate 2..20 do |comment|
        c_count += 1
        comment.category = "simple"
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
        ea.category = "simple"
        ea.event_attended = event.id
        ea.created_at = event.created_at..event.start_date
        ea.institution_id = 1

        # create one event view per attendee
        EventView.populate 1 do |view|
          view.user_id = ea.user_id
          view.category = "simple"
          view.event_viewed = event.id
          view.date_viewed = ea.created_at
          view.created_at = ea.created_at
          view.institution_id = 1
        end
      end

      # simple event has many event views
      max_count = 2 * ea_count
      EventView.populate 5..max_count do |ev|
        ev.user_id = 1..500
        ev.category = "simple"
        ev.event_viewed = event.id
        ev.date_viewed = event.created_at..Time.now
        ev.created_at = event.created_at..Time.now
        ev.institution_id = 1
      end

      # simple event has many likes
      Like.populate 5..ea_count do |like|
        like.liker_type = "User"
        like.liker_id = 1..500
        like.likeable_type = "SimpleEvent"
        like.likeable_id = event.id
        like.created_at = event.created_at..Time.now
      end

    end

  end
end

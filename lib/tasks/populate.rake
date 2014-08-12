namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [User, Subscription, Circle, CircleMember, Department, Club, AthleticTeam].each(&:delete_all)

    User.populate 500 do |user|
      user.institution_id = 1
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.email = Faker::Internet.email
      user.blurb = Populator.sentences(1..3)
      user.created_at = 2.years.ago..Time.now

      Subscription.populate 5..20 do |subscription|
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
  end
end

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task["db:reset"].invoke if Rails.env.development?
    make_users
    make_questions
    make_answers
  end

  def make_users
    puts "---------creating users--------------------"
    user = User.new(
                 username: "mars124",
                 email: "mars125@o2.pl",
                 password: "asdasdasd",
                 password_confirmation: "asdasdasd",
                 points: 1000
                 )
    user.skip_confirmation!
    user.save
    99.times do |n|
      username  = "Username_#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      user = User.new(
                   username: username,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   points: 1000
                   )
      user.skip_confirmation!
      user.save
    end
  end

  def make_questions
    puts "---------creating questions---------------"
    users = User.all.order(:id).limit(6)
    # puts users.pluck(:id)
    50.times do
      title = Faker::Lorem.sentence(1)
      contents = Faker::Lorem.sentence(20)
      users.each { |user| user.questions.create!(
                                                  title: title,
                                                  contents: contents
                                                  ) }
    end
  end

  def make_answers
    puts "---------creating answers---------------"
    # questions = Question.all.limit(6)
    users = User.all.order(:id).limit(6)
    # puts users.pluck(:id)

    5.times do |n|
      n += 1
      contents = Faker::Lorem.sentence(100)
      users.each { |user| user.questions.each {|question| question.answers.create!(
                                                        contents: contents,
                                                        user_id: n
                                                        ) }
                  }
    end
  end
end

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
    User.create!(
                 username: "mars124",
                 email: "mars124@o2.pl",
                 password: "asdasdasd",
                 password_confirmation: "asdasdasd"
                 )
    99.times do |n|
      username  = "Username_#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(
                   username: username,
                   email: email,
                   password: password,
                   password_confirmation: password
                   )
    end
  end

  def make_questions
    puts "---------creating questions---------------"
    users = User.all.limit(6)
    50.times do
      title = Faker::Lorem.sentence(3)
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
    users = User.all.limit(6)

    5.times do |n|
      n += 1
      contents = Faker::Lorem.sentence(100)
      users.each { |user| user.questions.first.answers.create!(
                                                  contents: contents,
                                                  user_id: n
                                                  ) }
    end
  end

end

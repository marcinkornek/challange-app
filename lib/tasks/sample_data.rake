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
                 email: "example@railstutorial.org",
                 password: "asdasdasd",
                 password_confirmation: "asdasdasd"
                 )
    99.times do |n|
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(
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
      contents = Faker::Lorem.sentence(10)
      users.each { |user| user.questions.create!(
                                                  title: title,
                                                  contents: contents
                                                  ) }
    end
  end

  def make_answers
    puts "---------creating answers---------------"
    questions = Question.all.limit(6)
    5.times do
      contents = Faker::Lorem.sentence(10)
      questions.each { |question| question.answers.create!(
                                                  contents: contents,
                                                  user_id: 1
                                                  ) }
    end
  end

end

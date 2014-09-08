require 'spec_helper'

describe Question do

  let(:user) { FactoryGirl.create(:user) }
  before { @question = user.questions.build(title: "Lorem ipsum", contents: "dolor sit amet, consectetur adipiscing elit, sed do eiusmod") }

  subject { @question }

  it { should respond_to(:title) }
  it { should respond_to(:contents) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:answers) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @question.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @question.title = " " }
    it { should_not be_valid }
  end

  describe "with blank contents" do
    before { @question.contents = " " }
    it { should_not be_valid }
  end

  describe "with a question title that's too long" do
    before { @question.title = "a" * 61 }
    it { should_not be_valid }
  end

  # describe "questions associations" do
  #   let!(:older_question) do
  #     FactoryGirl.create(:question, user: user, created_at: 1.day.ago)
  #   end
  #   let!(:newer_question) do
  #     FactoryGirl.create(:question, user: user, created_at: 1.hour.ago)
  #   end

  #   it "should have the right questions in the right order" do
  #     puts newer_question.title
  #     puts older_question.created_at
  #     # puts user.questions.to_a
  #     expect(user.questions.to_a).to eq [newer_question, older_question]
  #   end

    # it "should destroy associated microposts" do
    #   microposts = @user.microposts.to_a
    #   @user.destroy
    #   expect(microposts).not_to be_empty
    #   microposts.each do |micropost|
    #     expect(Micropost.where(id: micropost.id)).to be_empty
    #   end
    # end

  # end
end

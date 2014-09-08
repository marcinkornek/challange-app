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

  describe "destroying questions should destroy question answers" do
  end
end

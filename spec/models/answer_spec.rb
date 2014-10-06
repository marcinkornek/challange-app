require 'spec_helper'

describe Answer do

  let(:user)      { FactoryGirl.create(:confirmed_user) }
  let(:question)  { FactoryGirl.create(:question) }

  before { @answer = question.answers.build(contents: "tempor incididunt ut labore et dolore magna aliqua.", user: user) }

  subject { @answer }

  it { should respond_to(:contents) }
  it { should respond_to(:question_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:question) }
  it { should respond_to(:points) }
  it { should respond_to(:opinions) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @answer.user_id = nil }
    it { should_not be_valid }
  end

  describe "when question_id is not present" do
    before { @answer.question_id = nil }
    it { should_not be_valid }
  end

  describe "with blank contents" do
    before { @answer.contents = " " }
    it { should_not be_valid }
  end

end

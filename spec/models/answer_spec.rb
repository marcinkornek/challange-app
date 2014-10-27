require 'spec_helper'

describe Answer do

  let(:user)      { FactoryGirl.create(:confirmed_user) }
  let(:question)  { FactoryGirl.create(:question) }

  before { @answer = question.answers.build(contents: "tempor incididunt ut labore et dolore magna aliqua.", user: user) }

  it { expect(@answer).to respond_to(:contents) }
  it { expect(@answer).to respond_to(:question_id) }
  it { expect(@answer).to respond_to(:user_id) }
  it { expect(@answer).to respond_to(:user) }
  it { expect(@answer).to respond_to(:question) }
  it { expect(@answer).to respond_to(:points) }
  it { expect(@answer).to respond_to(:opinions) }

  it { expect(@answer).to be_valid }

  describe "when user_id is not present" do
    before { @answer.user_id = nil }
    it { expect(@answer).not_to be_valid }
  end

  describe "when question_id is not present" do
    before { @answer.question_id = nil }
    it { expect(@answer).not_to be_valid }
  end

  describe "with blank contents" do
    before { @answer.contents = " " }
    it { expect(@answer).not_to be_valid }
  end

end

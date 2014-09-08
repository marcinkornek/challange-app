require 'spec_helper'

describe QuestionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  describe "signed in user" do
    describe "can destroy own questions" do

    end

    describe "cant destroy other questions" do
    end
  end
end

require 'spec_helper'

describe "User pages" do
  include SpecHelpers::Authorization

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in_as user
      visit users_path
    end

    it { should have_title('Users') }
    it { should have_content('Users') }
  end
end


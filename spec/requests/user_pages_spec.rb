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

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('.pagination') }

      it "should list each user" do
        User.paginate(page: 1, per_page: 20).each do |user|
          expect(page).to have_selector('li', text: user.username)
          expect(page).to have_selector('li', text: user.questions.count)
        end
      end
    end
  end
end


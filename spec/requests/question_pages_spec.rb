require 'spec_helper'

describe "QuestionPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "question creation" do
    before { visit new_question_path }

    describe "with invalid information" do

      context 'with blank title and content' do
        it "should not create a question" do
          expect { click_button "Save" }.not_to change(Question, :count)
        end
      end

      context 'with blank title' do
        before { fill_in 'question_contents', with: "Lorem ipsum" }
        it "should not create a question" do
          expect { click_button "Save" }.not_to change(Question, :count)
        end

        describe "error messages" do
          before { click_button "Save" }
          it { should have_content('error') }
        end

      end

      context 'with blank content' do
        before { fill_in 'question_title', with: "Lorem ipsum" }
        it "should not create a question" do
          expect { click_button "Save" }.not_to change(Question, :count)
        end
      end
    end

    describe "with valid information" do
      before do
        fill_in 'question_contents',  with: "Lorem ipsum"
        fill_in 'question_title',     with: "Lorem ipsum"
      end

      it "should create a question" do
        expect { click_button "Save" }.to change(Question, :count)
      end
    end

    # describe "pagination" do
    #   before(:all) do
    #     @user = FactoryGirl.create(:user, username: 'other_username', email: 'other_username@o2.pl')
    #     20.times { FactoryGirl.create(:question, @user) }
    #   end

    #   after(:all)  { Question.delete_all }


    #   it { should have_selector('.pagination') }

    #   it "should list each question" do
    #     Question.paginate(page: 1, per_page: 10).each do |question|
    #       expect(page).to have_selector('li', text: question.title)
    #       expect(page).to have_selector('div', text: question.answers.count)
    #     end
    #   end
    # end

  end
end

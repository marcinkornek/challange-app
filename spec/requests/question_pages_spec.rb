require 'spec_helper'

describe "QuestionPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:confirmed_user) }
  before { sign_in user }

  describe "question creation" do
    before { visit new_question_path }

    describe "with invalid information" do

      context 'with blank title and content' do
        it "should not create a question" do
          expect { click_button "Create question" }.not_to change(Question, :count)
        end
      end

      context 'with blank title' do
        before { fill_in 'question_contents', with: "Lorem ipsum" }
        it "should not create a question" do
          expect { click_button "Create question" }.not_to change(Question, :count)
        end

        describe "error messages" do
          before { click_button "Create question" }
          it { should have_content('error') }
        end

      end

      context 'with blank content' do
        before { fill_in 'question_title', with: "Lorem ipsum" }
        it "should not create a question" do
          expect { click_button "Create question" }.not_to change(Question, :count)
        end
      end
    end

    describe "with valid information" do
      context 'without tags' do
        before do
          fill_in 'question_contents',  with: "Lorem ipsum"
          fill_in 'question_title',     with: "Lorem ipsum"
        end

        it "should create a question" do
          expect { click_button "Create question" }.to change(Question, :count)
        end
      end

      context 'with tags' do
        before do
          fill_in 'question_contents',  with: "Lorem ipsum"
          fill_in 'question_title',     with: "Lorem ipsum"
          fill_in 'question_tag_list',  with: "Rails"
        end

        it "should create a question" do
          expect { click_button "Create question" }.to change(Question, :count)
        end

        describe "can see tags links in his questions" do
          before do
            click_button "Create question"
          end

          it { should have_content('Tags: Rails') }
          it { should have_link('Tags', href: tags_path) }
          it { should have_link('Rails', href: tag_path('Rails')) }
        end
      end
    end

    describe "signed in user" do
      let(:other_user)          { FactoryGirl.create(:confirmed_user) }
      let(:user_question)       { FactoryGirl.create(:question, user: user) }
      let(:other_user_question) { FactoryGirl.create(:question, title: 'other title', user: other_user) }

      describe "can see edit and destroy links in his questions" do
        before do
          visit question_path(user_question)
        end
        it do
          should have_content('Delete')
          should have_content('Edit |')
          should have_content(user_question.contents)
        end
      end

      describe "cant see edit and destroy links in other questions" do
        before do
          visit question_path(other_user_question)
        end
        it do
          should_not have_content('Delete')
          should_not have_content('Edit |')
          should have_content(other_user_question.contents)
        end
      end


    end


  end
end

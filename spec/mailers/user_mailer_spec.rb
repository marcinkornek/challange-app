require "spec_helper"

describe UserMailer do

  before do
    @user               = FactoryGirl.create(:user)
    @other_user         = FactoryGirl.create(:user)
    @user_question      = FactoryGirl.create(:question, user: @user)
    @other_user_answer  = FactoryGirl.create(:answer, user: @other_user, question: @user_question)
  end

  describe "#accept_answer" do

    let(:mail) { UserMailer.accept_answer(@other_user_answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Accepted answer")
      expect(mail.to).to      eq([@other_user.email])
      expect(mail.from).to    eq(["no-reply@challangeapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your answer to question &#39;#{@user_question.title}&#39; has been accepted")
      expect(mail.body.encoded).to match("Link to question")
    end
  end

  describe "#password_changed" do

    let(:mail) { UserMailer.password_changed(@user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your password has changed")
      expect(mail.to).to      eq([@user.email])
      expect(mail.from).to    eq(["no-reply@challangeapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your password has changed")
      expect(mail.body.encoded).to match("Hi #{@user.username}")
      expect(mail.body.encoded).to match("We wanted to let you know that your password was changed.")
    end
  end

  describe "#new_answer" do

    let(:mail) { UserMailer.new_answer(@other_user_answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to      eq([@user.email])
      expect(mail.from).to    eq(["no-reply@challangeapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your have new answer to question &#39;#{@user_question.title}&#39;")
      expect(mail.body.encoded).to match("Link to question")
    end
  end
end

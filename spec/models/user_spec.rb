require 'spec_helper'

describe User do

  before { @user = User.new(username: 'example_username', email: "user@example.com", password: "asdasdasd",
                            password_confirmation: "asdasdasd") }

  it { expect(@user).to respond_to(:email) }
  it { expect(@user).to respond_to(:password) }
  it { expect(@user).to respond_to(:password_confirmation) }
  it { expect(@user).to respond_to(:answers) }
  it { expect(@user).to respond_to(:questions) }
  it { expect(@user).to respond_to(:notifications) }
  it { expect(@user).to respond_to(:avatar) }
  it { expect(@user).to respond_to(:points) }
  it { expect(@user).to respond_to(:send_new_message_email) }
  it { expect(@user).to respond_to(:send_accepted_answer_email) }
  it { expect(@user).to respond_to(:friendly_token) }
  it { expect(@user).to respond_to(:provider) }
  it { expect(@user).to respond_to(:uid) }

  it { expect(@user).to be_valid }

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
      @user.save
    end

    it { expect(@user).not_to be_valid }
  end

  describe "when password is not present" do
    before { @user.password = ''}
    it { expect(@user).not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { expect(@user).not_to be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { expect(@user).not_to be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "valid users" do
    let(:password) { "andou_zine" }
    let(:user) do
      User.new(name: "Hebron George", email: "me@hebrongeorge.com",
               password: password, password_confirmation: password)
    end

    it { expect(user.valid?).to eq true }
  end

  describe "email address validations" do
    let(:name) { "Hebron George" }
    let(:valid_addresses) do
      %w[users@example.com USER@foo.COM A_US-ER@foo.bar.org
         first.last@foo.jq alice+bob@baz.cn]
    end
    let(:invalid_addresses) do
      %w[users@example,com user_at_foo.org users.name@example.
         foo@bar_baz.com foo@bar+baz.com]
    end
    let(:password) { "there_are_a_100_billion_other_galaxies" }
    it "allows valid emails" do
      valid_addresses.each do |email|
        user = User.new(name: name, email: email,
                        password: password, password_confirmation: password)
        expect(user.valid?).to eq(true), "#{email} should be valid"
      end
    end

    it "does not allow invalid emails" do
      invalid_addresses.each do |email|
        user = User.new(name: name, email: email,
                        password: password, password_confirmation: password)
        expect(user.valid?).to eq(false), "#{email} should be invalid"
      end
    end

    it "does not allow duplicate emails" do
      user1 = User.new(name: name, email: "hello@world.net",
                       password: password, password_confirmation: password)
      user1.save
      user2 = User.new(name: "Tony Stark", email: "HELLO@world.net",
                       password: password, password_confirmation: password)
      expect(user2.valid?).to eq false
    end

    it "saves mixed case as downcased" do
      user = User.new(name: name, email: "hElLoWorLD@example.net",
                      password: password, password_confirmation: password)
      user.save
      expect(user.email).to eq("helloworld@example.net")
    end
  end

  describe "invalid users" do
    let(:user) do
      User.new(name: name, email: email,
               password: password, password_confirmation: password)
    end
    let(:name) { "Hebron George" }
    let(:email) { "me@hebrongeorge.com" }
    let(:password) { "we_began_as_wanderers_and_we_are_wanderers_still" }

    context "blank name" do
      let(:name) { "      " }
      it { expect(user.valid?).to eq false }
    end

    context "blank email" do
      let(:email) { "     " }
      it { expect(user.valid?).to eq false }
    end

    context "long name" do
      let(:name) { "a" * 51 }
      it { expect(user.valid?).to eq false }
    end

    context "short name" do
      let(:name) { "a" * 3 }
      it { expect(user.valid?).to eq false }
    end

    context "long email" do
      let(:email) { "#{"a" * 244}@example.com" }
      it { expect(user.valid?).to eq false }
    end

    context "passwords" do
      context "when blank" do
        let(:password) { "    " }
        it { expect(user.valid?).to eq(false) }
      end

      context "when too short" do
        let(:password) { "abcdefg" }
        it { expect(user.valid?).to eq(false) }
      end
    end
  end

  describe "account activation" do
    let(:user) { FactoryBot.create(:user) }

    it "has an activation_token and corresponding activation_digest generated" do
      expect(user.activation_token).to_not eq nil
      expect(user.activation_digest).to_not eq nil
    end

    it "activation token is equivalent to digest" do
      expect(BCrypt::Password.new(user.activation_digest).is_password?(user.activation_token)).to eq true
    end
  end
end

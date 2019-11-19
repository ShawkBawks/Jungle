require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should create a User if all of the validations pass' do
      @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
      @user.valid?
      expect(@user.errors).not_to include("can\'t be blank")
    end
    
    it 'should not create a User if the First name is missing' do
      @user = User.new(last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
      @user.valid?
      expect(@user.errors[:first_name]).to include("can\'t be blank")
    end

    it 'should not create a User if the Last name is missing' do
      @user = User.new(first_name: "Bort", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
      @user.valid?
      expect(@user.errors[:last_name]).to include("can\'t be blank")
    end

    it 'should not create a User if the email is missing' do
      @user = User.new(first_name: "Bort", last_name:"Sampsonite", password: "1234", password_confirmation: "1234")
      @user.valid?
      expect(@user.errors[:email]).to include("can\'t be blank")
    end

    it 'should not create a User if email is not unique' do
      @user1 = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
      @user1.save
      @user2 = User.new(first_name: "Joben", last_name: "Rudd", email: "BORTsampsonite@email.com", password: "1234", password_confirmation: "1234")
      @user2.valid?
      expect(@user2.errors[:email]).to include("has already been taken")
    end

    it 'should not create a User if password is missing' do
      @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com")
      @user.valid?
      expect(@user.errors[:password_digest]).to include("can\'t be blank")
    end

    it 'should not create a User if passwords do not match' do
      @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "12345")
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("doesn\'t match Password")
    end
    
    it 'should not create a User if password is too short' do
      @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1", password_confirmation: "1")
      @user.valid?
      expect(@user.errors[:password]).to include("is too short (minimum is 4 characters)")
    end
  end

    describe '.authenticate_with_credentials' do
      it 'should log the user in if the credentials are correct' do
        @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
        @user.save!
        expect(User.authenticate_with_credentials("bortsampsonite@email.com", "1234")).to be_present
      end
      it 'should not log in the user if the password is wrong' do
        @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
        @user.save!
        expect(User.authenticate_with_credentials("bortsampsonite@email.com", "12345")).not_to be_present
      end
      
      it 'should not log the user in if the email is wrong' do
        @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
        @user.save!
        expect(User.authenticate_with_credentials("bortsamps@email.com", "1234")).not_to be_present
      end

      it 'should log in even if the User email contains spaces' do
        @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
        @user.save!
        expect(User.authenticate_with_credentials(" bortsampsonite@email.com    ", "1234")).to be_present
      end

      it 'should log in the user even if the email contains different case values' do
        @user = User.new(first_name: "Bort", last_name: "Sampsonite", email: "bortsampsonite@email.com", password: "1234", password_confirmation: "1234")
        @user.save!
        expect(User.authenticate_with_credentials("   BORTSAMPsonite@email.com       ", "1234")).to be_present
      end
    end
end
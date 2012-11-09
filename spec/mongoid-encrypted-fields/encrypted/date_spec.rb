require 'spec_helper'

module Mongoid
  module Encrypted
    describe Date do

      before(:all) do
        Mongoid::Encrypted::Config.cipher = Mongoid::Ciphers::SymmetricCipher.new(algorithm: 'aes-256-cbc', password: 'my test password')
      end

      let(:raw) { Date.today }
      let(:encrypted) { Mongoid::Encrypted::Date.mongoize(Date.today.to_s) }

      it "returns the same date" do
        Mongoid::Encrypted::Date.from_date(raw).should eq(raw)
      end

      it "should encrypt the date" do
        Mongoid::Encrypted::Date.from_date(raw).encrypted.should eq(encrypted)
      end

      it "nil should fail" do
        -> { Mongoid::Encrypted::Date.from_date(nil) }.should raise_error()
      end

      describe "demongoize" do

        it "nil should return nil" do
          Mongoid::Encrypted::Date.demongoize(nil).should be_nil
        end

        it "empty date should return empty date" do
          Mongoid::Encrypted::Date.demongoize('').should eq('')
        end

        it "invalid date should fail" do
          -> { Mongoid::Encrypted::Date.demongoize('not a date') }.should raise_error
        end

        it "encrypted date should return instance of Mongoid::Encrypted::Date" do
        end

        it "encrypted date should return unencrypted date" do
          decrypted = Mongoid::Encrypted::Date.demongoize(encrypted)
          decrypted.is_a?(Mongoid::Encrypted::Date).should be_true
          decrypted.should eq(raw)
        end

      end

      describe "mongoize" do

        it "encrypted date should return encrypted" do
          Mongoid::Encrypted::Date.mongoize(Mongoid::Encrypted::Date.from_date(raw)).should eq(encrypted)
        end

        it "encrypted date should return itself" do
          Mongoid::Encrypted::Date.mongoize(encrypted).should eq(encrypted)
        end

        it "nil should return nil" do
          Mongoid::Encrypted::Date.mongoize(nil).should eq(nil)
        end

        it "empty date should return nil" do
          Mongoid::Encrypted::Date.mongoize('').should eq(nil)
        end

        it "non empty date should return encrypted" do
          Mongoid::Encrypted::Date.mongoize(raw).should eq(encrypted)
        end

      end

    end
  end
end
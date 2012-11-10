require 'spec_helper'

module Mongoid
  describe EncryptedDate do

    before(:all) do
      Mongoid::EncryptedFields.cipher = Mongoid::Ciphers::SymmetricCipher.new(algorithm: 'aes-256-cbc', password: 'my test password')
    end

    let(:raw) { Date.today }
    let(:encrypted) { Mongoid::EncryptedDate.mongoize(Date.today) }

    it "returns the same date" do
      Mongoid::EncryptedDate.from_date(raw).should eq(raw)
    end

    it "should encrypt the date" do
      Mongoid::EncryptedDate.from_date(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { Mongoid::EncryptedDate.from_date(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        Mongoid::EncryptedDate.demongoize(nil).should be_nil
      end

      it "empty date should return empty date" do
        Mongoid::EncryptedDate.demongoize('').should eq('')
      end

      it "invalid date should fail" do
        -> { Mongoid::EncryptedDate.demongoize('not a date') }.should raise_error
      end

      it "encrypted date should return instance of Mongoid::EncryptedDate" do
      end

      it "encrypted date should return unencrypted date" do
        decrypted = Mongoid::EncryptedDate.demongoize(encrypted)
        decrypted.is_a?(Mongoid::EncryptedDate).should be_true
        decrypted.should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted date should return encrypted" do
        Mongoid::EncryptedDate.mongoize(Mongoid::EncryptedDate.from_date(raw)).should eq(encrypted)
      end

      it "encrypted date should return itself" do
        Mongoid::EncryptedDate.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        Mongoid::EncryptedDate.mongoize(nil).should eq(nil)
      end

      it "non empty date should return encrypted" do
        Mongoid::EncryptedDate.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
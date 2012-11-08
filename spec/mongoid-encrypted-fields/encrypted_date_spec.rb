require 'spec_helper'

module Mongoid
  describe EncryptedDate do

    before(:all) do
      EncryptedStrings::SymmetricCipher.default_algorithm = 'aes-256-cbc'
      EncryptedStrings::SymmetricCipher.default_password = 'my test password'
    end

    let(:raw) { Date.today }
    let(:encrypted) { Date.today.to_s.encrypt(:symmetric) }

    it "returns the same date" do
      EncryptedDate.from_date(raw).should eq(raw)
    end

    it "should encrypt the date" do
      EncryptedDate.from_date(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { EncryptedDate.from_date(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        EncryptedDate.demongoize(nil).should be_nil
      end

      it "empty date should return empty date" do
        EncryptedDate.demongoize('').should eq('')
      end

      it "invalid date should fail" do
        -> { EncryptedDate.demongoize('not a date') }.should raise_error
      end

      it "encrypted date should return instance of EncryptedDate" do
      end

      it "encrypted date should return unencrypted date" do
        decrypted = EncryptedDate.demongoize(encrypted)
        decrypted.is_a?(EncryptedDate).should be_true
        decrypted.should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted date should return encrypted" do
        EncryptedDate.mongoize(EncryptedDate.from_date(raw)).should eq(encrypted)
      end

      it "encrypted date should return itself" do
        EncryptedDate.mongoize(encrypted).should be(encrypted)
      end

      it "nil should return nil" do
        EncryptedDate.mongoize(nil).should eq(nil)
      end

      it "empty date should return nil" do
        EncryptedDate.mongoize('').should eq(nil)
      end

      it "non empty date should return encrypted" do
        EncryptedDate.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
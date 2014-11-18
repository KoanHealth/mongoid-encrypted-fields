require 'spec_helper'

module Mongoid
  describe EncryptedString do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    let(:raw) { "abc123" }
    let(:encrypted) { Mongoid::EncryptedString.new("abc123").encrypted }

    it "returns the same string" do
      Mongoid::EncryptedString.new(raw).should eq(raw)
    end

    it "should encrypt the string" do
      Mongoid::EncryptedString.new(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { Mongoid::EncryptedString.new(nil) }.should raise_error()
    end

    it "modified string automatically encrypts after change" do
      str = "this is a test"
      es = Mongoid::EncryptedString.new(str)
      es.encrypted.should eq(Mongoid::EncryptedString.encrypt(str))

      es.chop!
      es.encrypted.should eq(Mongoid::EncryptedString.encrypt(str.chop))
    end

    describe "demongoize" do

      it "nil should return nil" do
        Mongoid::EncryptedString.demongoize(nil).should be_nil
      end

      it "empty string should return empty string" do
        Mongoid::EncryptedString.demongoize('').should eq('')
      end

      it "encrypted string should return instance of Mongoid::EncryptedString" do
        Mongoid::EncryptedString.demongoize(encrypted).is_a?(Mongoid::EncryptedString).should be true
      end

      it "encrypted string should return unencrypted string" do
        Mongoid::EncryptedString.demongoize(encrypted).should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted string should return encrypted" do
        Mongoid::EncryptedString.mongoize(Mongoid::EncryptedString.new(raw)).should eq(encrypted)
      end

      it "encrypted string should return itself" do
        Mongoid::EncryptedString.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        Mongoid::EncryptedString.mongoize(nil).should eq(nil)
      end

      it "empty string should return empty string" do
        Mongoid::EncryptedString.mongoize('').should eq('')
      end

      it "non empty string should return encrypted" do
        Mongoid::EncryptedString.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
require 'spec_helper'

module Mongoid
  describe EncryptedHash do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    subject { Mongoid::EncryptedHash }
    let(:raw) { {street: "123 Main St", city: "Springdale", state: "MD"} }
    let(:encrypted) { Mongoid::EncryptedHash.mongoize({street: "123 Main St", city: "Springdale", state: "MD"}) }

    it "returns the same hash" do
      subject.from_hash(raw).should eq(raw)
    end

    it "should encrypt the hash" do
      subject.from_hash(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { subject.from_hash(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        subject.demongoize(nil).should be_nil
      end

      it "blank string should return blank string" do
        subject.demongoize('').should eq('')
      end

      it "invalid hash should fail" do
        -> { subject.demongoize('not a hash') }.should raise_error
      end

      it "encrypted hash should return unencrypted hash" do
        decrypted = subject.demongoize(encrypted)
        decrypted.is_a?(subject).should be true
        decrypted.should eq(raw.stringify_keys)
      end

    end

    describe "mongoize" do

      it "encrypted hash should return encrypted" do
        subject.mongoize(subject.from_hash(raw)).should eq(encrypted)
      end

      it "encrypted hash should return itself" do
        subject.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        subject.mongoize(nil).should eq(nil)
      end

      it "valid hash should return encrypted" do
        subject.mongoize(raw).should eq(encrypted)
      end

    end

  end
end

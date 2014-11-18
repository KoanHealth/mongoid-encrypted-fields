require 'spec_helper'

module Mongoid
  describe EncryptedDateTime do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    subject { Mongoid::EncryptedDateTime }
    let(:raw) { DateTime.new(2010, 6, 15, 1, 2, 3) }
    let(:encrypted) { Mongoid::EncryptedDateTime.mongoize(DateTime.new(2010, 6, 15, 1, 2, 3)) }

    it "returns the same datetime" do
      subject.from_datetime(raw).should eq(raw)
    end

    it "should encrypt the datetime" do
      subject.from_datetime(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { subject.from_datetime(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        subject.demongoize(nil).should be_nil
      end

      it "blank string should return blank string" do
        subject.demongoize('').should eq('')
      end

      it "invalid datetime should fail" do
        -> { subject.demongoize('not a date') }.should raise_error
      end

      it "encrypted datetime should return unencrypted datetime" do
        decrypted = subject.demongoize(encrypted)
        decrypted.is_a?(subject).should be true
        decrypted.should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted datetime should return encrypted" do
        subject.mongoize(subject.from_datetime(raw)).should eq(encrypted)
      end

      it "encrypted datetime should return itself" do
        subject.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        subject.mongoize(nil).should eq(nil)
      end

      it "valid datetime should return encrypted" do
        subject.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
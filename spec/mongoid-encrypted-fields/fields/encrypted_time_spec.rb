require 'spec_helper'

module Mongoid
  describe EncryptedTime do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    subject { Mongoid::EncryptedTime }
    let(:raw) { Time.at(946702800) }
    let(:encrypted) { Mongoid::EncryptedTime.mongoize(Time.at(946702800)) }

    it "returns the same time" do
      subject.from_time(raw).should eq(raw)
    end

    it "should encrypt the time" do
      subject.from_time(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { subject.from_time(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        subject.demongoize(nil).should be_nil
      end

      it "blank should return itself" do
        subject.demongoize('').should eq('')
      end

      it "invalid time should fail" do
        -> { subject.demongoize('not a time') }.should raise_error
      end

      it "encrypted time should return unencrypted time" do
        decrypted = subject.demongoize(encrypted)
        decrypted.is_a?(subject).should be true
        decrypted.should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted time should return encrypted" do
        subject.mongoize(subject.from_time(raw)).should eq(encrypted)
      end

      it "encrypted time should return itself" do
        subject.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        subject.mongoize(nil).should eq(nil)
      end

      it "non empty time should return encrypted" do
        subject.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
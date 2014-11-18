require 'spec_helper'

module Mongoid
  describe EncryptedDate do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    subject { Mongoid::EncryptedDate }
    let(:raw) { Date.today }
    let(:encrypted) { Mongoid::EncryptedDate.mongoize(Date.today) }

    it "returns the same date" do
      subject.from_date(raw).should eq(raw)
    end

    it "should encrypt the date" do
      subject.from_date(raw).encrypted.should eq(encrypted)
    end

    it "nil should fail" do
      -> { subject.from_date(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        subject.demongoize(nil).should be_nil
      end

      it "blank should return itself" do
        subject.demongoize('').should eq('')
      end

      it "invalid date should fail" do
        -> { subject.demongoize('not a date') }.should raise_error
      end

      it "encrypted date should return unencrypted date" do
        decrypted = subject.demongoize(encrypted)
        decrypted.is_a?(subject).should be true
        decrypted.should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted date should return encrypted" do
        subject.mongoize(subject.from_date(raw)).should eq(encrypted)
      end

      it "encrypted date should return itself" do
        subject.mongoize(encrypted).should eq(encrypted)
      end

      it "nil should return nil" do
        subject.mongoize(nil).should eq(nil)
      end

      it "non empty date should return encrypted" do
        subject.mongoize(raw).should eq(encrypted)
      end

    end

  end
end
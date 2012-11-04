require 'spec_helper'

module Mongoid
  describe EncryptedString do

    before(:all) do
      EncryptedStrings::SymmetricCipher.default_algorithm = 'aes-256-cbc'
      EncryptedStrings::SymmetricCipher.default_password = 'my test password'
    end

    let(:raw_string) { "abc123" }

    it "returns the same string" do
      EncryptedString.new(raw_string).should eq(raw_string)
    end

    it "should encrypt the string" do
      EncryptedString.new(raw_string).encrypted.should eq(raw_string.encrypt(:symmetric))
    end

  end
end
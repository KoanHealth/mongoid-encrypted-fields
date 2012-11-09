require 'spec_helper'

module Mongoid
  module Encrypted
    describe String do

      before(:all) do
        Mongoid::Encrypted::Config.cipher = Mongoid::Ciphers::SymmetricCipher.new(algorithm: 'aes-256-cbc', password: 'my test password')
      end

      let(:raw) { "abc123" }
      let(:encrypted) { Mongoid::Encrypted::String.mongoize("abc123") }

      it "returns the same string" do
        Mongoid::Encrypted::String.new(raw).should eq(raw)
      end

      it "should encrypt the string" do
        Mongoid::Encrypted::String.new(raw).encrypted.should eq(encrypted)
      end

      it "nil should fail" do
        -> { Mongoid::Encrypted::String.new(nil) }.should raise_error()
      end

      it "modified string automatically encrypts after change" do
        str = "this is a test"
        es = Mongoid::Encrypted::String.new(str)
        es.encrypted.should eq(Mongoid::Encrypted::Config.cipher.encrypt(str))

        es.chop!
        es.encrypted.should eq(Mongoid::Encrypted::Config.cipher.encrypt(str.chop))
      end

      describe "demongoize" do

        it "nil should return nil" do
          Mongoid::Encrypted::String.demongoize(nil).should be_nil
        end

        it "empty string should return empty string" do
          Mongoid::Encrypted::String.demongoize('').should eq('')
        end

        it "encrypted string should return instance of Mongoid::Encrypted::String" do
          Mongoid::Encrypted::String.demongoize(encrypted).is_a?(Mongoid::Encrypted::String).should be_true
        end

        it "encrypted string should return unencrypted string" do
          Mongoid::Encrypted::String.demongoize(encrypted).should eq(raw)
        end

      end

      describe "mongoize" do

        it "encrypted string should return encrypted" do
          Mongoid::Encrypted::String.mongoize(Mongoid::Encrypted::String.new(raw)).should eq(encrypted)
        end

        it "encrypted string should return itself" do
          Mongoid::Encrypted::String.mongoize(encrypted).should eq(encrypted)
        end

        it "nil should return nil" do
          Mongoid::Encrypted::String.mongoize(nil).should eq(nil)
        end

        it "empty string should return empty string" do
          Mongoid::Encrypted::String.mongoize('').should eq('')
        end

        it "non empty string should return encrypted" do
          Mongoid::Encrypted::String.mongoize(raw).should eq(encrypted)
        end

      end

    end
  end
end
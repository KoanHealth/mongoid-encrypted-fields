require 'spec_helper'

describe 'Single model' do

  before(:all) do
    EncryptedStrings::SymmetricCipher.default_algorithm = 'aes-256-cbc'
    EncryptedStrings::SymmetricCipher.default_password = 'a really strong password'
  end

  let (:ssn) { '123456789' }
  let (:ssn_encrypted) { '123456789'.encrypt(:symmetric) }
  let (:person) { Person.new(name: 'John Doe', ssn: '123456789') }

  it "model stores encrypted value" do
    person.attributes['ssn'].should eq(ssn_encrypted)
  end

  it "encrypted field getter returns raw value" do
    person.ssn.should eq(ssn)
  end

  describe "after save" do

    before(:each) do
      Mongoid.purge!
      person.save!
      @persisted = Person.find(person.id)
    end

    it "encrypted field is persisted" do
      @persisted.attributes['ssn'].should eq(ssn_encrypted)
    end

    it "encrypted field getter returns raw value" do
      @persisted.ssn.should eq(ssn)
    end

  end

  describe "find model by encrypted field" do

    before(:each) do
      Mongoid.purge!
      person.save!
    end

    it "matches equality" do
      Person.where(ssn: ssn).count.should eq(1)
    end

  end

end
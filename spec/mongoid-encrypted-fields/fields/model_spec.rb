require 'spec_helper'

describe 'Single model' do

  before(:all) do
    Mongoid::EncryptedFields.cipher = Mongoid::Ciphers::SymmetricCipher.new(algorithm: 'aes-256-cbc', password: 'my test password')
  end

  let (:ssn) { '123456789' }
  let (:ssn_encrypted) { Mongoid::EncryptedString.mongoize('123456789') }
  let (:birth_date) { 20.years.ago.to_date }
  let (:birth_date_encrypted) { Mongoid::EncryptedDate.mongoize(20.years.ago.to_date) }
  let (:person) { Person.new(name: 'John Doe', ssn: '123456789', birth_date: 20.years.ago.to_date) }

  it "model stores encrypted ssn" do
    person.attributes['ssn'].should eq(ssn_encrypted)
  end

  it "model stores encrypted birth_date" do
    person.attributes['birth_date'].should eq(birth_date_encrypted)
  end

  it "ssn getter returns raw value" do
    person.ssn.should eq(ssn)
  end

  it "birth_date getter returns raw value" do
    person.birth_date.should eq(birth_date)
  end

  describe "after save" do

    before(:each) do
      Mongoid.purge!
      person.save!
      @persisted = Person.find(person.id)
    end

    it "encrypted ssn is persisted" do
      @persisted.attributes['ssn'].should eq(ssn_encrypted)
    end

    it "encrypted birth_date is persisted" do
      @persisted.attributes['birth_date'].should eq(birth_date_encrypted)
    end

    it "encrypted ssn getter returns raw value" do
      @persisted.ssn.should eq(ssn)
    end

    it "encrypted birth_date getter returns raw value" do
      @persisted.birth_date.should eq(birth_date)
    end

  end

  describe "find model by encrypted field" do

    before(:each) do
      Mongoid.purge!
      person.save!
    end

    it "ssn matches equality" do
      Person.where(ssn: ssn).count.should eq(1)
    end

    it "birth date matches equality" do
      Person.where(birth_date: birth_date).count.should eq(1)
    end

  end

end
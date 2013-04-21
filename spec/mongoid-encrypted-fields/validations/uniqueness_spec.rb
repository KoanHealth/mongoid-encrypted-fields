require "spec_helper"

describe Mongoid::Validations::UniquenessValidator do

  before(:all) do
    Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
  end

  before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end

  describe "#valid?" do

    let(:person) do
      Person.new(name: "bill", ssn: "123456789")
    end

    after do
      Person.reset_callbacks(:validate)
    end

    context "when the value is in conflict" do

      context "when the field is encrypted" do

        before do
          Person.validates_uniqueness_of :name
          Person.create!(name: "bill")
        end

        it "correctly detects a uniqueness conflict" do
          expect(person).to_not be_valid
        end
      end

      context "when the field is not encrypted" do

        before do
          Person.validates_uniqueness_of :ssn
          Person.create!(ssn: "123456789")
        end

        it "correctly detects a uniqueness conflict" do
          expect(person).to_not be_valid
        end
      end
    end

    context "when the value is not conflict" do

      context "when the field is encrypted" do

        before do
          Person.validates_uniqueness_of :name
          Person.create!(name: "ted")
        end

        it "correctly detects a uniqueness conflict" do
          expect(person).to be_valid
        end
      end

      context "when the field is not encrypted" do

        before do
          Person.validates_uniqueness_of :ssn
          Person.create!(ssn: "223456789")
        end

        it "correctly detects a uniqueness conflict" do
          expect(person).to be_valid
        end
      end
    end
  end
end
require "spec_helper"

if Mongoid::EncryptedFields.mongoid_major_version >= 4
  describe Mongoid::Validatable::UniquenessValidator do

    before(:all) do
      Mongoid::EncryptedFields.cipher = GibberishCipher.new('my test password', 'weaksalt')
    end

    before(:each) do
      Mongoid.purge!
    end

    describe "#valid?" do

      let(:person) do
        Person.new(name: "bill", ssn: "abc456789", credit_card: "12345678", phone_number: "12345678")
      end

      after do
        Person.reset_callbacks(:validate)
      end

      context "when the value is in conflict" do

        context "when the field is not encrypted" do

          context "when the validation is case-sensitive" do

            before do
              Person.validates_uniqueness_of :name, case_sensitive: true
              Person.create!(name: "bill")
            end

            it "correctly detects a uniqueness conflict" do
              expect(person).to_not be_valid
            end
          end

          context "when the validation is case-insensitive" do

            before do
              Person.validates_uniqueness_of :name, case_sensitive: false
              Person.create!(name: "BiLl")
            end

            it "behaves as case-insensitive" do
              expect(person).to_not be_valid
            end
          end
        end

        context "when the field is encrypted" do

          context "when the validation is case-sensitive" do

            before do
              Person.validates_uniqueness_of :ssn
              Person.create!(ssn: "abc456789")
            end

            it "behaves as case-sensitive" do
              expect(person).not_to be_valid
            end
          end

          context "when the validation is case-insensitive" do

            it "throws an exception" do
              expect { Person.validates_uniqueness_of :ssn, case_sensitive: false }.to raise_error 'Encrypted field :ssn cannot support case insensitive uniqueness'
            end

          end
        end
      end

      context "when the value is not conflict" do

        context "when the field is not encrypted" do

          before do
            Person.validates_uniqueness_of :name
            Person.create!(name: "ted")
          end

          it "correctly detects a uniqueness conflict" do
            expect(person).to be_valid
          end
        end

        context "when the field is encrypted" do

          before do
            Person.validates_uniqueness_of :ssn
            Person.create!(ssn: "223456789")
          end

          it "correctly detects a uniqueness conflict" do
            expect(person).to be_valid
          end
        end
      end

      context "when the field name is aliased" do

        context "when the aliased name is used" do

          context "when the field is encrypted" do

            it "throws an exception" do
              expect { Person.validates_uniqueness_of :credit_card, case_sensitive: false }.to raise_error 'Encrypted field :credit_card cannot support case insensitive uniqueness'
            end
          end

          context "when the field is not encrypted" do

            before do
              Person.validates_uniqueness_of :phone_number, case_sensitive: false
              Person.create!(phone_number: "12345678")
            end

            it "correctly detects a uniqueness conflict" do
              expect(person).to_not be_valid
            end
          end
        end

        context "when the underlying name is used" do

          context "when the field is encrypted" do

            it "throws an exception" do
              expect { Person.validates_uniqueness_of :cc, case_sensitive: false }.to raise_error 'Encrypted field :cc cannot support case insensitive uniqueness'
            end
          end

          context "when the field is not encrypted" do

            before do
              Person.validates :ph, uniqueness: {case_sensitive: false}
              Person.create!(phone_number: "12345678")
            end

            it "correctly detects a uniqueness conflict" do
              expect(person).to_not be_valid
            end
          end
        end
      end
    end
  end
end
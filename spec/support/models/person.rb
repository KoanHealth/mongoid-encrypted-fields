class Person
  include Mongoid::Document

  field :name, type: String
  field :ssn, type: Mongoid::EncryptedString
  field :birth_date, type: Mongoid::EncryptedDate
  field :address, type: Mongoid::EncryptedHash

end
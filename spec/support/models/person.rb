class Person
  include Mongoid::Document

  field :name, type: String
  field :ssn, type: Mongoid::EncryptedString

end
class Person
  include Mongoid::Document

  field :name, type: String
  field :ssn, type: Mongoid::Encrypted::String
  field :birth_date, type: Mongoid::Encrypted::Date

end
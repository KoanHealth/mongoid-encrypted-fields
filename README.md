mongoid-encrypted-fields
========================

A library for storing encrypted data in Mongo using Mongoid.  We looked at a view alternatives, but wanted something that stored the values securely, yet remained unobtrusive to our code.

Mongoid 3 supports [custom types](http://mongoid.org/en/mongoid/docs/documents.html) that need to only provide a simple interface - allowing us to extend core Ruby types to secure any type while providing a clean interface for developers.

Queries encrypt data before searching the database, so equality matches work automatically.

## Prerequisites

* Ruby 1.9.3
* [Mongoid](http://mongoid.org) 3.0
* [Encrypted-Strings](https://github.com/pluginaweek/encrypted_strings)

## Install
    gem 'mongoid-encrypted-fields'

## Usage
* Configure encrypted_strings setting the cipher and password:
    EncryptedStrings::SymmetricCipher.default_algorithm = 'aes-256-cbc'
    EncryptedStrings::SymmetricCipher.default_password = ENV['MY_PASSWORD'] # please don't hard code this
* Use encrypted types for fields in your models:
    class Person
        include Mongoid::Document

        field :name, type: String
        field :ssn, type: Mongoid::EncryptedString
    end
* The field getter returns the unencrypted value:
    person = Person.new(ssn: '123456789')
    person.ssn # => '123456789'
* The encrypted value is accessible with the "encrypted" attribute
    person.ssn.encrypted # => <encrypted string>
* Finding a model by an encrypted field works automatically (equality only):
    Person.where(ssn: '123456789').count()

## Known Limitations
* Only supports symmetric encryption
* Single password for all encrypted fields

## Future Enhancements
* Implement encryption for other types: numerics, dates, etc...

## Copyright
(c) 2012 Koan Health. See LICENSE.txt for further details.
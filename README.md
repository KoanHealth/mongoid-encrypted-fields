mongoid-encrypted-fields
========================

A library for storing encrypted data in Mongo using Mongoid.  We looked at a few alternatives, but wanted something that stored the values securely and unobtrusively.

Mongoid 3 supports [custom types](http://mongoid.org/en/mongoid/docs/documents.html) that need to only provide a simple interface - allowing us to extend core Ruby types to secure any type while providing a clean interface for developers.

Queries encrypt data before searching the database, so equality matches work automatically.

## Prerequisites
* Ruby 1.9.3
* [Mongoid](http://mongoid.org) 3.0
* [Encrypted-Strings](https://github.com/pluginaweek/encrypted_strings)

## Install
    gem 'mongoid-encrypted-fields'

## Usage
* Configure the cipher to be used for encrypting field values:
    ```Ruby
    Mongoid::EncryptedFields.cipher = Mongoid::Ciphers::SymmetricCipher.new(algorithm: 'aes-256-cbc', password: ENV['MY_PASSWORD']) # find a secure way to get your password
    ```
* Use encrypted types for fields in your models:
    ```Ruby
    class Person
        include Mongoid::Document

        field :name, type: String
        field :ssn, type: Mongoid::EncryptedString
    end
    ```
* The field getter returns the unencrypted value:
    ```Ruby
    person = Person.new(ssn: '123456789')
    person.ssn # => '123456789'
    ```
* The encrypted value is accessible with the "encrypted" attribute
    ```Ruby
    person.ssn.encrypted # => <encrypted string>
    ```
* Finding a model by an encrypted field works automatically (equality only):
    ```Ruby
    Person.where(ssn: '123456789').count() # ssn is encrypted before querying the database
    ```

## Known Limitations
* Single cipher for all encrypted fields

## Copyright
(c) 2012 Koan Health. See LICENSE.txt for further details.
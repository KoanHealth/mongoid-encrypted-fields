mongoid-encrypted-fields
========================

A library for storing encrypted data in Mongo using Mongoid.  We looked at a few alternatives, but wanted something that stored the values securely and unobtrusively.

Mongoid 3 supports [custom types](http://mongoid.org/en/mongoid/docs/documents.html) that need to only provide a simple interface - allowing us to extend core Ruby types to secure any type while providing a clean interface for developers.

Queries encrypt data before searching the database, so equality matches work automatically.

## Prerequisites
* Ruby 1.9.3
* [Mongoid](http://mongoid.org) 3.0
* "Bring your own" encryption, see below

## Install
    gem 'mongoid-encrypted-fields'

## Usage
* Configure the cipher to be used for encrypting field values:

    Gibberish::AES can be found in examples - uses the [Gibberish](https://github.com/mdp/gibberish) gem:
```Ruby
    Mongoid::EncryptedFields.cipher = Gibberish::AES.new(ENV['MY_PASSWORD'], ENV['MY_SALT'])
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

    # It can also be accessed using the hash syntax supported by Mongoid
    person[:ssn] # => <encrypted string>
    ```
* Finding a model by an encrypted field works automatically (equality only):
    ```Ruby
    Person.where(ssn: '123456789').count() # ssn is encrypted before querying the database
    ```

## Known Limitations
* Single cipher for all encrypted fields
* Currently can encrypt these [Mongoid types](http://mongoid.org/en/mongoid/docs/documents.html#fields)
  * Date
  * DateTime
  * Hash
  * String
  * Time

## Copyright
(c) 2012 Koan Health. See LICENSE.txt for further details.

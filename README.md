mongoid-encrypted-fields
========================
[![Build Status](https://secure.travis-ci.org/KoanHealth/mongoid-encrypted-fields.png?branch=master&.png)](http://travis-ci.org/KoanHealth/mongoid-encrypted-fields)
[![Code Climate](https://codeclimate.com/github/KoanHealth/mongoid-encrypted-fields.png)](https://codeclimate.com/github/KoanHealth/mongoid-encrypted-fields)

New Maintainer Needed
=====================
We are actively seeking a new maintainer for this gem!  As we no longer use MongoDB as part of our platform, we aren't using the gem for ourselves.  As MongoDB and Mongoid continually change, we want to make sure our gem keeps up.

If you're interested, please contact us!  Thanks

Description
===========
A library for storing encrypted data in Mongo using Mongoid.  We looked at a few alternatives, but wanted something that stored the values securely and unobtrusively.

Mongoid 3 supports [custom types](http://mongoid.org/en/mongoid/docs/documents.html) that need to only provide a simple interface - allowing us to extend core Ruby types to secure any type while providing a clean interface for developers.

Queries encrypt data before searching the database, so equality matches work automatically.

## Prerequisites

* [Mongoid](http://mongoid.org) 5+
* Rails 4+
* Ruby 2.0+
* "Bring your own" encryption, see below

Mongoid 3, Mongoid 4 and Rails 3.2 are supported in version 1.x of this gem.

## Install

    ```ruby
    gem 'mongoid-encrypted-fields'
    ```

## Usage
* Configure the cipher to be used for encrypting field values:

    GibberishCipher can be found in the [examples](https://github.com/KoanHealth/mongoid-encrypted-fields/tree/master/examples) - uses the [Gibberish](https://github.com/mdp/gibberish) gem:

    ```ruby
    Mongoid::EncryptedFields.cipher = GibberishCipher.new(ENV['MY_PASSWORD'], ENV['MY_SALT'])
    ```

* Use encrypted types for fields in your models:

    ```ruby
    class Person
        include Mongoid::Document

        field :name, type: String
        field :ssn, type: Mongoid::EncryptedString
    end
    ```

* The field getter returns the unencrypted value:

    ```ruby
    person = Person.new(ssn: '123456789')
    person.ssn # => '123456789'
    ```

* The encrypted value is accessible with the "encrypted" attribute

    ```ruby
    person.ssn.encrypted # => <encrypted string>

    # It can also be accessed using the hash syntax supported by Mongoid
    person[:ssn] # => <encrypted string>
    ```

* Finding a model by an encrypted field works automatically (equality only):

    ```ruby
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
* The uniqueness validator for encrypted fields should always be set to case-sensitive.  Encrypted fields cannot support a case-insensitive match.

## Related Articles
* [Storing Encrypted Data in MongoDB](http://jerryclinesmith.me/blog/2013/03/29/storing-encrypted-data-in-mongodb/)
* [Transparently Adding Encrypted Fields to a Rails App using Mongoid](http://blog.thesparktree.com/post/69538763994/transparently-adding-encrypted-fields-to-a-rails-app)

## Copyright
(c) 2012 Koan Health. See LICENSE.txt for further details.

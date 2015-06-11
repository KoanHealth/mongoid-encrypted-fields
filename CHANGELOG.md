# Revision history

## 1.3.4
* \#21 Adding support for changes in Mongoid 5
* \#22 Check for nil field_type

## 1.3.3
* \#19 Remove deprecated Validator#setup method

## 1.3.2
* \#17 Updates due to changes in ActiveModel 4.2
* Added gemfiles to specifically test Mongoid 4, Mongoid 4 with Rails 4.1, and Mongoid 4 with Rails 4.2

## 1.3.1
* \#14 Updates due to changes in Mongoid 4 and ActiveModel 4

## 1.3.0 - Breaking change - PLEASE READ
* \#11 Support for Mongoid 4
* \#12 EncryptedHash will now stringify the keys before storing to be consistent with Mongoid's behavior

## 1.2.2
* Accepted [pull request](https://github.com/KoanHealth/mongoid-encrypted-fields/pull/10) to support aliased fields with the uniqueness validator (@johnnyshields)

## 1.2.1
* Uniqueness validator fails if developer attempts to use case-insensitive option for an encrypted field

## 1.2 - Add EncryptedHash
* Accepted [pull request](https://github.com/KoanHealth/mongoid-encrypted-fields/pull/4) to add support for encrypted hashes (@ashirazi)

## 1.1 - Breaking changes - PLEASE READ

### encrypted-strings gem
During performance testing, we've found the [encrypted-strings](https://github.com/pluginaweek/encrypted_strings) gem
to be very slow under load, and it's patching the == method on String so it has been removed as the default cipher option.

### Gibberish
[Gibberish](https://github.com/mdp/gibberish) was found to be very fast, but uses a unique salt for each encryption.
This is normally great for security, but becomes problematic for searching for encrypted fields in Mongoid because each
search would generate a unique value that wouldn't match what's stored in the database.

We've included classes in the **examples** folder to show implementations of using either of these Gems, but remember that
we only require a class that implements **encrypt** and **decrypt** so you can use any gem of your choice.

### Modifications

* Removed included cipher implementations
* Removed [encrypted-strings](https://github.com/pluginaweek/encrypted_strings) gem dependency

## 1.0 - Initial release

# Revision history

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

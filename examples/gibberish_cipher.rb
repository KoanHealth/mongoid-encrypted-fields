require 'gibberish/aes'

# Gibberish uses a unique salt for every encryption, but we need the same text to return the same ciphertext
# so Searching for encrypted field will work
class GibberishCipher < Gibberish::AES

  SALT = "OU812FTW" # TODO: If you use this example class, make a unique 8-byte salt for your project

  def initialize(password, options = {})
    super password, options[:size] || 256
    @salt = options[:salt] || SALT
  end

  def generate_salt
    return @salt if @salt
    super
  end

end
module Mongoid
  module Encrypted
    module Config
      class << self
        attr_accessor :cipher
      end
    end
  end
end
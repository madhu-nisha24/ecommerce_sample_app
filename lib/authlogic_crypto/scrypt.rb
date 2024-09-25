require 'scrypt'

module Authlogic
  module CryptoProviders
    class Scrypt
      def self.crypt(password, salt)
        SCrypt::Password.create(password, cost: 12, salt: salt)
      end

      def self.match?(password, crypted_password)
        SCrypt::Password.new(crypted_password) == password
      end

      def self.salt
        SCrypt::Engine.generate_salt
      end
    end
  end
end
# frozen_string_literal: true


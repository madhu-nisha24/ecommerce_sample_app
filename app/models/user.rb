class User < ApplicationRecord
  acts_as_authentic do |c|
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end
  has_many :orders
  validates :email, presence: true, uniqueness: true
  #validates :id, presence: true
end

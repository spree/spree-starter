class Spree::User < Spree.base_class
  include Spree::UserAddress
  include Spree::UserMethods
  include Spree::UserPaymentSource

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

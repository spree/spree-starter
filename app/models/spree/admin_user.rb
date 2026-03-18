class Spree::AdminUser < Spree.base_class
  include Spree::AdminUserMethods

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

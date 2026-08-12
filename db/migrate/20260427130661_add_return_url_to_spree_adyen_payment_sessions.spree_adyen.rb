# This migration comes from spree_adyen (originally 20250813152608)
class AddReturnUrlToSpreeAdyenPaymentSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_adyen_payment_sessions, :return_url, :string

    SpreeAdyen::PaymentSession.reset_column_information
    Spree::Store.find_each do |store|
      redirect_to = Spree::Core::Engine.routes.url_helpers.redirect_adyen_payment_session_url(host: store.url_or_custom_domain)
      store.payment_methods.adyen.find_each do |gateway|
        store.adyen_gateway.payment_sessions.with_deleted.where(return_url: nil).update_all(return_url: redirect_to)
      end
    end

    add_index :spree_adyen_payment_sessions, :return_url
  end
end
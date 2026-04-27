# This migration comes from spree_adyen (originally 20250811140113)
class AddChannelToAdyenPaymentSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_adyen_payment_sessions, :channel, :string

    SpreeAdyen::PaymentSession.reset_column_information
    SpreeAdyen::PaymentSession.where(channel: nil).update_all(channel: 'Web')

    add_index :spree_adyen_payment_sessions, :channel
  end
end

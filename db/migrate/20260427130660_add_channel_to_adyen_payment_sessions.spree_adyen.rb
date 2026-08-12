# This migration comes from spree_adyen (originally 20250811140113)
class AddChannelToAdyenPaymentSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_adyen_payment_sessions, :channel, :string

    # Backfilled through the connection rather than SpreeAdyen::PaymentSession:
    # spree_adyen is optional, so the model is absent whenever the gem is not
    # bundled and referencing it would abort the migration.
    up_only do
      execute("UPDATE spree_adyen_payment_sessions SET channel = 'Web' WHERE channel IS NULL")
    end

    add_index :spree_adyen_payment_sessions, :channel
  end
end

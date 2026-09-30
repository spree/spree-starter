class RemoveChannelIndexFromSolidCableMessages < ActiveRecord::Migration[8.1]
  # Solid Cable 4.x looks messages up by channel_hash; the channel index is unused.
  def up
    remove_index :solid_cable_messages, :channel, if_exists: true
  end

  def down
    add_index :solid_cable_messages, :channel, if_not_exists: true
  end
end

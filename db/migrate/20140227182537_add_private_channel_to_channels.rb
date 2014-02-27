class AddPrivateChannelToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :private_channel, :boolean, :default => false
  end
end

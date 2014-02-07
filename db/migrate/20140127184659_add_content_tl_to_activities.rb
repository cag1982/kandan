class AddContentTlToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :content_tl, :text
  end
end

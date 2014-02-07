class AddContentEnToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :content_en, :text
  end
end

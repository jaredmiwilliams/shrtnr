class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.string :original_url
      t.string :hashed_url
      t.string :hashed_edit_url
      t.string :created_by

      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end

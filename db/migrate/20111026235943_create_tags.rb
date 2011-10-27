class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :tag_value
      t.string :tag_normalized

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end

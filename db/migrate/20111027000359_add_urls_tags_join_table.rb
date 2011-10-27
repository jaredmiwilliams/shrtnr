class AddUrlsTagsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :urls_tags, :id => false do |t|
      t.integer :url_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :urls_tags
  end
end

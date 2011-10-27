class AddCountToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :count, :integer
  end

  def self.down
    remove_column :urls, :count
  end
end

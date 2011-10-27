class ChangeUrlsUrlType < ActiveRecord::Migration
  def self.up
    change_table :urls do |t|
      t.change :original_url, :text
    end
  end

  def self.down
  end
end

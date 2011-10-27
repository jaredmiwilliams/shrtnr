class RenameUrlsTagsToTagsUrls < ActiveRecord::Migration
  def self.up
    rename_table :urls_tags, :tags_urls
  end

  def self.down
    rename_table :tags_urls, :urls_tags
  end
end

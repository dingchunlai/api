class CreatePublishColumnGroups < ActiveRecord::Migration
  def self.up
    create_table :publish_column_groups do |t|
    end
  end

  def self.down
    drop_table :publish_column_groups
  end
end

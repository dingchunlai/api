class CreateHejiaPublishChannels < ActiveRecord::Migration
  def self.up
    create_table :hejia_publish_channels do |t|
    end
  end

  def self.down
    drop_table :hejia_publish_channels
  end
end

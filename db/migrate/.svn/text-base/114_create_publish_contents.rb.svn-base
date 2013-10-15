class CreatePublishContents < ActiveRecord::Migration
  def self.up
    create_table :publish_contents do |t|
      t.column :publish_column_id, :integer
      t.column :index_id, :integer
      t.column :entity_type_id, :integer
      t.column :entity_id, :integer
      t.column :title, :string
      t.column :description, :text
      t.column :resume, :string
      t.column :url, :string
      t.column :image_url, :string
      t.column :media_type_id, :integer, :null => false, :default => 0 #媒体类型，默认为0，表示无，1为图片，2为视频
      t.column :entity_created_at, :datetime
      t.column :entity_updated_at, :datetime
      t.column :entity_expired_at, :datetime
      t.column :order_id, :integer, :null => false, :default => 0 #排序码，默认为0 
      t.column :text_style_id, :integer, :null => false, :default => 0 #文本样式，默认为0，表示无样式,加粗为1，加红为2，加粗加红为3
      t.column :publish_time, :datetime #发布时间，默认为当前时间
      t.column :expire_time, :datetime, :default => '2050-01-01' #失效时间，默认为2030-01-01
      t.column :is_valid, :integer, :null => false, :default => 0 #默认为0，预发布为1，发布为2
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :publish_contents
  end
end

class CreatePublishTextStyles < ActiveRecord::Migration
  def self.up
    create_table :publish_text_styles do |t|
      t.column :style_name, :string
      t.column :style_key, :integer
      t.column :style_value, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :publish_text_styles
  end
end

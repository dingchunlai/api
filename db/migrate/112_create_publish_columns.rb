class CreatePublishColumns < ActiveRecord::Migration
  def self.up
    create_table :publish_columns do |t|
      t.column :editor_id, :integer
      t.column :name, :string
      t.column :description, :string
      t.column :is_valid, :integer, :null => false, :default => 1  #是否有效，默认为1，表示有效 
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :publish_columns
  end
end

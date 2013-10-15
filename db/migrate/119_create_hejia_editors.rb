class CreateHejiaEditors < ActiveRecord::Migration
  def self.up
    create_table :hejia_editors do |t|
    end
  end

  def self.down
    drop_table :hejia_editors
  end
end

class CreateRadminUsers < ActiveRecord::Migration
  def self.up
    create_table :radmin_users do |t|
    end
  end

  def self.down
    drop_table :radmin_users
  end
end

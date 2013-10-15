class CreateHejiaBbsUsers < ActiveRecord::Migration
  def self.up
    create_table :hejia_bbs_users do |t|
    end
  end

  def self.down
    drop_table :hejia_bbs_users
  end
end

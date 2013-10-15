class CreateHejiaVisitRecords < ActiveRecord::Migration
  def self.up
    create_table :hejia_visit_records do |t|
    end
  end

  def self.down
    drop_table :hejia_visit_records
  end
end

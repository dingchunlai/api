class CreateHejiaArtProdLinks < ActiveRecord::Migration
  def self.up
    create_table :hejia_art_prod_links do |t|
    end
  end

  def self.down
    drop_table :hejia_art_prod_links
  end
end

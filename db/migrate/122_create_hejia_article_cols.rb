class CreateHejiaArticleCols < ActiveRecord::Migration
  def self.up
    create_table :hejia_article_cols do |t|
    end
  end

  def self.down
    drop_table :hejia_article_cols
  end
end

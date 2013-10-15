class CreateHejiaArticleCategories < ActiveRecord::Migration
  def self.up
    create_table :hejia_article_categories do |t|
    end
  end

  def self.down
    drop_table :hejia_article_categories
  end
end

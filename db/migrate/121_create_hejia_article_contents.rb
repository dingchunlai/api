class CreateHejiaArticleContents < ActiveRecord::Migration
  def self.up
    create_table :hejia_article_contents do |t|
    end
  end

  def self.down
    drop_table :hejia_article_contents
  end
end

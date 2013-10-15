class PublishColumnGroup < ActiveRecord::Base
  belongs_to :user, :class_name => "RadminUser", :foreign_key => "editor_id"
  has_many :columns, :class_name => "PublishColumn", :conditions => ["is_del = ?", false]
  validates_presence_of :name
end

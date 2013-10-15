class DecoPhoto < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
  has_attached_file :image, :styles => { :thumb => "105x80>", :medium => "160x120" },
    :path => ":rails_root/public/decos/:class/:attachment/:id/:basename_:style.:extension",
    :url => "http://img.51hejia.com/decos/:class/:attachment/:id/:basename_:style.:extension",
    :default_url => "/images/missing.gif"

  belongs_to :firm, :class_name => "DecoFirm", :foreign_key => "entity_id"
  belongs_to :entity, :polymorphic => true
end

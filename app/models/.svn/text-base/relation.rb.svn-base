class Relation < Hejia::Db::Index
#  connect_to :index
#  acts_as_readonlyable [:read_only_51hejia_index]
  has_many :decoration_diaries, :conditions => "relation_type=7", :foreign_key => "entity_id"
end

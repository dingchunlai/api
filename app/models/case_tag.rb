class CaseTag < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
    self.table_name = "HEJIA_TAG"
    self.primary_key = "TAGID"
    
    has_and_belongs_to_many :decos,
    :class_name => "CaseDeco",
    :join_table => "HEJIA_TAG_ENTITY_LINK",
    :foreign_key => "TAGID",
    :association_foreign_key => "ENTITYID",
    :conditions =>["LINKTYPE = 'decoimg'"]
end

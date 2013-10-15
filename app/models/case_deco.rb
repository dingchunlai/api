class CaseDeco < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
    self.table_name = "HEJIA_DECOIMAGE"
    self.primary_key = "ID"

  has_and_belongs_to_many :tags,
  :class_name => "CaseTag",
  :join_table => "HEJIA_TAG_ENTITY_LINK",
  :foreign_key => "ENTITYID",
  :association_foreign_key => "TAGID",
  :conditions =>["LINKTYPE = 'decoimg'"]

  # below function not be used
  def  self.deco case_id,tag_id
    # case_id = 22771,tag_id = 4393
    p "============================="
    p "case_id is #{case_id}"
    p "============================="
    p "tag is #{tag_id}"
    p "============================="

    temp = find_by_sql(["select distinct deco.ID , deco.imagename,deco.introduce from HEJIA_DECOIMAGE as deco, HEJIA_TAG_ENTITY_LINK as link1 where deco.id=link1.entityId and deco.caseid=? and link1.LINKTYPE='decoimg' and link1.tagid=? ",case_id, tag_id])

  end
end



class CaseDesigner < Hejia::Db::Hejia
#  acts_as_readonlyable [:read_only_51hejia]
  self.table_name = "HEJIA_DESIGNERMODEL"
  self.primary_key = "ID"
  belongs_to :company,
    :class_name => "CaseCompany",
    :foreign_key => "COMPANY"
    
  has_many :cs,
    :class_name=>"Case",
    :foreign_key => "DESIGNERID",
    :conditions =>["STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0'"]
    
  has_many :cslist,
    :class_name=>"Case",
    :foreign_key => "DESIGNERID",
    :conditions =>["STATUS != '-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1' and ISCOMMEND='0'"],
    :limit=>3,
    :order=>"ID DESC"
   
   # get_firm_case_designer
   def self.firm_case_designer firm_id
     CACHE.fetch("/firms/firm_case_designer/#{firm_id}", 1.hour) do
        designers_sql = "select designers.* from HEJIA_DESIGNERMODEL designers, HEJIA_CASE cases "
        designers_sql.concat "where designers.COMPANY = #{firm_id} and cases.DESIGNERID = designers.ID  and cases.STATUS != '-100' and cases.ISNEWCASE = 1 and cases.ISZHUANGHUANG = '1' and cases.ISCOMMEND = '0' "
        designers_sql.concat "group by designers.ID order by designers.LIST_INDEX desc "
        CaseDesigner.find_by_sql designers_sql
     end
   end

end


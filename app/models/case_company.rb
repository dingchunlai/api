class CaseCompany < ActiveRecord::Base
  acts_as_readonlyable [:read_only_51hejia]
    self.table_name = "HEJIA_COMPANY"
    self.primary_key = "ID"
    
    has_many :cs,
    :class_name=>"Case",
    :foreign_key=>"COMPANYID",
    :conditions =>["STATUS != '-100' and ISCOMMEND='0'"],
    :order => "CREATEDATE DESC",
    :limit=>8
    
    has_many :ds,
    :class_name=>"CaseDesigner",
    :foreign_key=>"COMPANY",
    :conditions =>["STATUS != '-100'"],
    :limit=>8
    
    belongs_to :tagc,
    :class_name => "CaseTag",
    :foreign_key => "COMPANYAREA"
    
    belongs_to :csinfo,
    :class_name => "CaseCompanyInfo",
    :foreign_key => "ID"
    
    has_many :cf,
    :class_name=>"CaseFactoryCompany",
    :foreign_key=>"COMPANYID",
    :limit=>15
#    CaseFactoryCompany
      
#    belongs_to :tag,
#    :class_name => "CaseTag",
#    :foreign_key => "companyArea"
end

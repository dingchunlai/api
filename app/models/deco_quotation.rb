class DecoQuotation < ActiveRecord::Base
  has_and_belongs_to_many :firms, :class_name => "DecoFirm",
								:join_table => "deco_firms_quotations",
								:foreign_key => "quotation_id",
								:association_foreign_key => "firm_id",
                                :uniq => true
end

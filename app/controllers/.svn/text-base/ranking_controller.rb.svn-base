class RankingController < DecoController

  def index
    
#    @bookings = DecoFirm.find(:all, :limit => 10, :order => "bookings_count desc")
    @comments = get_firms_by_order(1,"comments_count desc")
    @total = get_firms_by_order(2, "praise desc")
    @design = get_firms_by_order(3, "design_praise desc")
#    @budget = DecoFirm.find(:all, :limit => 10, :order => "budget_score desc")
    @construction = get_firms_by_order(4, "construction_praise desc")
    @service = get_firms_by_order(5, "service_praise desc")
    @cases = get_firms_by_order(6, "cases_count desc")
#    @worksites = DecoFirm.find(:all, :limit => 10, :order => "worksites_count desc")
  end
  
  def get_firms_by_order(indexnum,order)
    key = "zhaozhuangxiu_paihangbang1_#{Time.now.strftime('%Y-%m-%d')}_#{indexnum}"
    DecoFirm
    if CACHE.get(key).nil?
      result = DecoFirm.find(:all, :limit => 10, :order => order)
      CACHE.set(key,result)
    else
      result = CACHE.get(key)
    end
    return result
  end
end

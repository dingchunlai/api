class PromotedFirmsController < ApplicationController
  
  layout false
  
  before_filter :validate_admin
    
  def index
        
  end
 
  def new
        
  end
  
  def open_div
    search = params[:search]
    @city = params[:city]
    if search.blank?
      render :partial => "/promoted_firms/second_new"
    else
      render :partial => "/promoted_firms/second_search"
    end
    
  end
  
  def find
    
  end
    
  def search
    price, model, district, style, city, order, except, category, villa, firm_id = params[:promoted].values_at(:price, :model, :district, :style, :city, :order_class, :except, :category, :villa, :firm_id)
    @promoted = PromotedFirm.find_city(city)
    if category.to_i == 1
      @promoted = @promoted.find_category(category)
    elsif villa.to_i == 1
      @promoted = @promoted.find_villa(villa)
    elsif firm_id.to_i.to_s == firm_id
      @promoted = @promoted.find(:all, :conditions => ["firms_id like '%?%'", firm_id.to_i])
    else
      @promoted = @promoted.find_except(except.to_i)
      @promoted = @promoted.find_style(style) unless style.to_i == -1
      @promoted = @promoted.find_price(price) unless price.to_i == -1
      @promoted = @promoted.find_district(district) unless district.to_i == -1
      @promoted = @promoted.find_model(model) unless model.to_i == -1
      @promoted = @promoted.find_order(order) unless order.to_i == -1
      @promoted = @promoted.find_category(category) if category.to_i == 0
      @promoted = @promoted.find_villa(villa) if villa.to_i == 0
    end
    render :partial => "/promoted_firms/firms_list"
  end

  
  def update
    firms_id = params[:firm_id].split(",")
    id = params[:id]
    PromotedFirm.update(id , {:firms_id => firms_id})
    render :json => { :result => true }.to_json
  end
  
 
  def create
    promoted = PromotedFirm.new(params[:promoted])
    if params[:promoted][:category].to_i == 1
      is_promoted = PromotedFirm.find_city(promoted.city).find_category(promoted.category).first
    elsif params[:promoted][:villa].to_i == 1
      is_promoted = PromotedFirm.find_city(promoted.city).find_villa(promoted.villa).first
    else
      is_promoted = PromotedFirm.find_city(promoted.city).find_style(promoted.style).find_price(promoted.price).find_district(promoted.district).find_model(promoted.model).find_order(promoted.order_class).find_except(promoted.except).first
    end
    if is_promoted.nil?
      promoted.created_at = Time.now.to_s(:db)
      promoted.updated_at = Time.now.to_s(:db)
      promoted.save
    end
    search
  end
    
  private
  def validate_admin
    if staff_logged_in?
      true
    else
      page_not_found!
      false
    end
  end
  
end
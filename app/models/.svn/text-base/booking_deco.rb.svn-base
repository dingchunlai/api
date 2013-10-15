# -*- coding: utf-8 -*-
class BookingDeco < ActiveRecord::Base
  validates_presence_of :name, :message => "姓名不能为空"
  validates_presence_of :address, :message => "地址不能为空"
  validates_presence_of :tel, :message => "电话不能为空"
  validates_presence_of :building_area, :message => "建筑面积不能为空"
  def validate
    errors.add(:preview_time, "预约时间错误要大于现在时间.") if preview_time < Time.now
  end

end

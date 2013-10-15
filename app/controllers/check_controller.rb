# 近段时间，奇怪的500错误不断，为了监测，特意增加了一个什么都不做的action。
class CheckController < ApplicationController
  def error; render :nothing => true, :status => 200 end
end

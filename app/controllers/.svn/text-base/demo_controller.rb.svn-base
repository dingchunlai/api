class DemoController < ApplicationController
  def view
    @graph = open_flash_chart_object(112,50, '/demo/pie', true, '/')
  end
  def pie
    data = [params[:vs].to_i, params[:s].to_i, params[:us].to_i]
#    3.times do |t|
#      data << rand(10) + 5
#    end
    
    g = Graph.new
    g.pie(80, '#ffffff', '{font-size: 0px; color: #404040; display:none}', false, false)
    g.pie_values(data, %w(满意 还行 不满意))
#    g.pie_values([33,33,33], %w(满意 还行 不满意))
    g.pie_slice_colors(%w(#ec561b #50b332 #068dc4))
    g.set_tool_tip("#val#")
    g.set_bg_color('#ffefe0')
#    g.title("Pie Chart", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render
  end
  
  def test
    
  end
end
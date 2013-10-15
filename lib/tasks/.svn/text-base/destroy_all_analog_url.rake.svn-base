p "being"
task :destroy_all_analog_url => :environment do
  p "开始删除#{10.days.ago.at_beginning_of_day.to_s(:db)}之前的数据"
  AnalogUrl.destroy_all("created_at < '#{10.days.ago.at_beginning_of_day.to_s(:db)}'")
  p "删除#{10.days.ago.at_beginning_of_day.to_s(:db)}之前的数据完成"
end
p "end"
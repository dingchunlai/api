require 'singleton'

module APIS
  module DB
    class CasesRemarkMigration
      include Singleton
#      area_id = 1 , type_id = 6 表示案例回复
      p " ******* star ******* Time = #{Time.now.strftime("%H:%M:%S")}"
      Reply.find(:all , :conditions => "area_id = 1 and type_id = 6 and is_delete = 0").each_with_index do |reply, index|
        remark = Remark.new
        remark.ip = reply.ip
        remark.created_at = reply.created_at
        remark.updated_at = reply.updated_at
        remark.user_id = reply.user_id
        remark.content = reply.content
        remark.resource_type = "Case"
        remark.resource_id = reply.entity_id
        remark.save
      end       
      p " ******* end ******* Time = #{Time.now.strftime("%H:%M:%S")}"
    end
  end
end
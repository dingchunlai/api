require 'yaml'
require 'singleton'

module APIS
  module DB
    class CreateRemarksMigration
      include Singleton
      def run!
        time = Time.now
        puts " Loading ...."
        puts " Create DecoFirm remarks .... "
        deco_firm_remarks = YAML.load_file("c.yml")
        deco_firm_remarks.each_with_index do |firm, index|
          if index < 1
            puts "Create Loaded. Time cost: #{Time.now - time}ms"
          end
          firm["留言"] && firm["留言"].each do |firm_remark|
            remark = Remark.new
            remark.resource_id = firm["公司"]
            remark.resource_type = "DecoFirm"
            remark.user_id = firm_remark["用户"]
            remark.created_at = firm_remark["时间"]
            remark.content = firm_remark["内容"]
            remark.save
          end
          puts "DecoFirm Finished #{index} [#{firm['公司']}] records."
        end
        puts " Created_DecoFirm end  "
      end
    end
  end
end
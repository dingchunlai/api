require 'singleton'

module APIS
  module DB
    class RemarkCountMigration
      include Singleton
      def run!
        time = Time.now
        p ' Loading ....  '
        p ' start DecoFirm....  '
        Remark.find(:all, :select => "resource_id, count(resource_id) as remark_count", :conditions => "resource_type = 'DecoFirm' and resource_id is not null", :group => "resource_id", :order => "resource_id ASC").each_with_index do |remark, index|
          if index < 1
            puts "DecoFirm Loaded. Time cost: #{Time.now - time}ms"
          end
          if index % 100 == 0
            puts "DecoFirm Finished #{index} records."
          end
          firm = DecoFirm.find_by_id remark.resource_id
          firm.update_attribute(:remarks_count, remark.remark_count) unless firm.blank?
        end
        p ' end DecoFirm .... ........... '
        p ' start DecorationDiary....  '
        Remark.find(:all, :select => "resource_id, count(resource_id) as remark_count", :conditions => "resource_type = 'DecorationDiary' and resource_id is not null", :group => "resource_id", :order => "resource_id ASC").each_with_index do |remark, index|
          if index < 1
            puts "DecorationDiary Loaded. Time cost: #{Time.now - time}ms"
          end
          if index % 100 == 0
            puts "DecorationDiary Finished #{index} records."
          end
          diary = DecorationDiary.find_by_id remark.resource_id
          diary.update_attribute(:remarks_count, remark.remark_count) unless diary.blank?
        end
        p ' end DecorationDiary .... ........... '
      end
    end
  end
end
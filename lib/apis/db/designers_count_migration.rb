require 'singleton'

module APIS
  module DB
    class DesignersCountMigration
      include Singleton
      def run!
        time = Time.now
        p ' Loading ....  '
        p ' start DecoFirm....  '
        HejiaDesigner.find(:all, :select => "COMPANY , count(COMPANY) as designer_count", :conditions => "COMPANY is not null", :group => "COMPANY").each_with_index do |designer, index|
          firm = DecoFirm.find_by_id designer.COMPANY
          firm.update_attribute(:designers_count, designer.designer_count) unless firm.blank?
        end
        p ' end DecoFirm .... ........... '
      end
    end
  end
end
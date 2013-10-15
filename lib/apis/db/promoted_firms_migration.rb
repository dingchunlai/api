require 'singleton'

module APIS
  module DB
    class PromotedFirmsMigration
      include Singleton
      def run!
        p "star......"
        CITIES.each do |city,v|
          p "star **** #{TAGURLS[city]} *** time #{Time.now.to_s(:db)}"
          PROMOTED_COMPANIES[TAGURLS[city]][:only].each do |result|
            order = result[0][:order].nil? ? 0 : result[0][:order].to_i
            price = result[0][:price].nil? ? 0 : result[0][:price].to_i
            style = result[0][:style].nil? ? 0 : result[0][:style].to_i
            district = result[0][:district].nil? ? 0 : result[0][:district].to_i
            model = result[0][:model].nil? ? 0 : result[0][:model].to_i
            created_at = Time.now.to_s(:db)
            updated_at = Time.now.to_s(:db)
            firms_id = result[1]
            PromotedFirm.create(:city => city.to_i,:district => district,:created_at => created_at , :updated_at => created_at,
                      :price => price , :style => style , :model => model, :order_class => order, :firms_id => firms_id, :except => 0)
          end
          p "end ***** #{TAGURLS[city]} *** time #{Time.now.to_s(:db)}"
        end
        p "star except ****"
        PromotedFirm.create(:city => 12306,:district => 0,:created_at => Time.now.to_s(:db) , :updated_at => Time.now.to_s(:db),
                    :price => 0 , :style => 0 , :model => 0, :order_class => 2, :firms_id => [256303], :except => 1)
        p "end except ****"
        p "**********all end*****************"
      end
    end
  end
end
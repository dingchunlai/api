require "singleton"


begin
  ::Object.send :remove_const, 'Remark'
rescue NameError
  # Remark is not loaded yet, that's aready.
end

module APIS
  module DB
    class MigrationEventsReview
      include Singleton
      def run!
	    time = Time.now
        # formid = 88 and c34 = 1表示回复且为优惠券的
        DecoReply.find(:all, :select => "c1, userip, c2, cdate, udate, c3, c30 ", :conditions => ["formid = ? and c34 = ? ", HUIFU_ID, 1]).each_with_index do |reply, index|
	    puts " costs time : #{Time.now - time}ms  " if index < 1
          puts "  migation_index  ::  #{index}" if index % 20 == 0 
    	  remark = Remark.new
    	  remark.ip = reply.userip
    	  remark.created_at = reply.cdate;
    	  remark.updated_at = reply.udate;
    	  remark.user_id = reply.user_id
    	  remark.content = reply.content
    	  remark.resource_type = "DecoEvent"
    	  remark.resource_id = reply.review_id
          remark.save
        end       
        puts "  The end  ...  "
      end
    end
  end
end

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake. 
require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :apis do
  namespace :db do
    desc "set (DecoFirm || DecorationDiary) reamrks_count value"
    task :migtation_remarks_count_migtation => :environment do
      require 'apis/db/remarks_count_migration'
      APIS::DB::RemarkCountMigration.instance.run!
    end
    desc "migration create deco_firm remarks "
    task :migtate_deco_firm_remark_migtation => :environment do
      require 'apis/db/create_remarks_migration'
      APIS::DB::CreateRemarksMigration.instance.run!
    end
    desc "set DecoFirm designers_count value "
    task :deco_firm_designers_count_migtation => :environment do
      require 'apis/db/designers_count_migration'
      APIS::DB::DesignersCountMigration.instance.run!
    end
    desc "migration events review into remarks"
    task :events_review_into_remarks_migration => :environment do 
      require 'apis/db/migration_events_review'
      APIS::DB::MigrationEventsReview.instance.run!
    end  
    desc "set case reply into remarks"
    task :case_reply_into_remarks_migration => :environment do 
      require 'apis/db/cases_remark_migration'
      APIS::DB::CasesRemarkMigration.instance.run!
    end
    desc "set promoted_firms into database"
    task :promoted_firms_into_database => :environment do 
      require 'apis/db/promoted_firms_migration'
      APIS::DB::PromotedFirmsMigration.instance.run!
    end 
  end
end

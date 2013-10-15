namespace :afp do
  task :add_ad => :environment do
    show_usage = lambda { puts "\e[1m\e[32mUsage:\e[0m rake afp:add_ad afp_ad=url,id,p1,p2,rate,started_at,ended_at[,link]" }

    ad = ENV['afp_ad'] || ENV['AFP_AD']

    unless ad
      show_usage.call
      exit
    end

    url, id, p1, p2, rate, started_at, ended_at, link = ad.split ',', 8
    ad = AfpAd.new :url => url,
                   :ad_id => id,
                   :p1 => p1,
                   :p2 => p2,
                   :rate => rate,
                   :started_at => started_at,
                   :ended_at => ended_at,
                   :link => link
    if ad.save
      puts "\e[32mAd successfully added!\e[0m"
    else
      puts "\e[1m\e[31mCounld not add ad, because:\e[0m\e[1m\n\t- #{ad.errors.full_messages.join "\n\t- "}\e[0m"
      show_usage.call
    end
  end

  task :clear => :environment do
    AfpAd.clear_expired_ads
    puts "\e[1m\e[32mDone.\e[0m"
  end
end

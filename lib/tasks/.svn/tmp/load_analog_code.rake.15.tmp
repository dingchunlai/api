require 'yaml'
desc 'load analog code from yaml start'
task :load_analog_code => :environment do
  AnalogCode.destroy_all
  AnalogCodeUrl.destroy_all
  #AnalogUrl.destroy_all
  file_path = ENV['YAML']
  analog_codes = YAML.load_file(file_path)
  analog_codes.each do |ac|
    AnalogCode.create(:code => ac["code"], :max_hits => ac["max_hits"])
    ac["analog_code_urls"].each do |url|
      AnalogCodeUrl.create(:code => ac["code"], :url => url)
    end
  end
end
desc 'load analog code from yaml end'
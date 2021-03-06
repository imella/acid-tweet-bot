module AcidJobsBot
  
  class Bot 
    
    def initialize
      @@config ||= AcidJobsBot::Config.new
      
      input   = File.read(File.join('config','database.yml'))
      output  = Erubis::Eruby.new(input).result
      ActiveRecord::Base.establish_connection(YAML.load(output)[ENV['ENV'] ? ENV['ENV'] : 'development'])
      
      Twitter.configure do |config|
        config.consumer_key = @@config.consumer_key
        config.consumer_secret = @@config.consumer_secret
        config.oauth_token = @@config.oauth_token
        config.oauth_token_secret = @@config.oauth_token_secret
      end
    end
    
    def tweet_offer(offer)
      Twitter.update(offer)
    end
    
    def run
      puts "Running AcidTweetBot"
      c = AcidJobsBot::JobOffer.count
      if  c > 0
         offer = AcidJobsBot::JobOffer.find(:first,  :offset => rand(c))
         tweet_offer(offer)
      else
         # create the table?   CreateJobOffers.up
         # add a record?
         puts 'No records en the db'
      end 
    end

  end
end



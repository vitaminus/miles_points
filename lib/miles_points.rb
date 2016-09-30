require "miles_points/version"
require "miles_points/amex"
require "miles_points/barclay"
require "miles_points/wells_fargo"
require "miles_points/hawaiian_miles"
require "miles_points/jet_blue"
require "miles_points/southwest_rapid_rewards"
require "miles_points/spirit"
require "miles_points/mileage_plus"
require "miles_points/virgin_america"
require "miles_points/aadvantage"
require "miles_points/mileage_plan"
require "miles_points/sky_miles"
require "miles_points/choise_privileges"
require "miles_points/ba"
require "miles_points/hilton_hhonors"
require "miles_points/marriott"
require "miles_points/chase"
require "miles_points/jet_cash"

module MilesPoints
  def self.take(klass)
    i = 0
    begin
      klass = klass.gsub(/(_|-)/,' ').split.map(&:capitalize).join('')
      const_get(klass).new.scrape_data
    rescue Exception => e
      # puts e.message
      # correct_klass = e.message.scan(/(  MilesPoints::.+)/).flatten.compact.first
      return { message: "#{klass.capitalize} currently switched off or doesn't exist." } if e.message.include?('uninitialized constant')
      if i < 3
        retry
      else
        return { error: "#{klass.capitalize} currently not available" }
      end
    end
  end
end

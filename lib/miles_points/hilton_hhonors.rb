require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class HiltonHHonors
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 15

    def scrape_data
      result = []
      visit "http://shoptoearn.hhonors.com/loyrewards/earnmall/us/allMerchants?selectedTab=tab2"
      sleep 3
      page.all('.content-item').each do |pm|
        merch_name = pm.all('a.evnt-show_merchant')[2].text
        value = pm.find('.new-point').text
        link = pm.all('a.evnt-show_merchant')[2][:href]
        offer = pm.all('span.list-view-offer-icon').size > 0
        result << { merch_name: merch_name, value: value, link: link, offer: offer }
      end
      Capybara.reset_sessions!
      result
    end
  end
end
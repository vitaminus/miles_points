require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class WellsFargo
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 12, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 5

    def scrape_data
      result = []
      visit "https://emm.wellsfargorewards.com/dhtdocs/members/benefits.php?sid=121XXdKrlo121&view=offerslist&rewards=t"
      sleep 2
      # save_and_open_page
      page.all('ul.retailers_list').each do |pm|
        pm.all('li').each do |mp|
          merch_name = mp.find('a').text
          value = mp.find('span').text
          link = mp.find('li a')[:href]
          result << { merch_name: merch_name, value: value, link: link }
        end
      end
      Capybara.reset_sessions!
      result
    end
  end
end
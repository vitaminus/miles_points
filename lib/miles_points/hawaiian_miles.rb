require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class HawaiianMiles
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 20, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 10

    def scrape_data
      result = []
      visit "https://onlinemall.hawaiianairlines.com/ha/#show/stores/"
      find('.gm')
      # puts all('.gm').size
      until all('.gm').size == 0
        find('.gm').click
      end
      # save_and_open_page
      page.all('li.block').each do |pm|
        merch_name = pm.find('a img')[:alt]
        value = pm.all('span')[0].text
        link = pm.all('a')[0][:href]
        deals = pm.all('a')[2].text if pm.all('a').size > 2
        deals_link = pm.all('a')[2][:href] if pm.all('a').size > 2
        img = pm.find('a img')[:src]
        result << { merch_name: merch_name, value: value, link: link, deals: deals, deals_link: deals_link, img: img }
      end
      Capybara.reset_sessions!
      result
    end
  end
end
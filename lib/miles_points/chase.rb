require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

module MilesPoints

  class Chase
    include Capybara::DSL
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, window_size: [1920, 1080], timeout: 20, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
    end
    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_max_wait_time = 15

    def scrape_data
      t = Time.now
      result = []
      visit "http://www.cashbackmonitor.com/credit-card-points-comparison/1/"
      sleep 2
      # save_and_open_page
      freedom = []
      ink = []
      sapphire = []
      c = 0
      until c == all('td.nb.b').size - 1 do
        sleep 2
        c += 1
        full_table = page.find('table.cbm')
        full_table.all('tr').each do |pm|
          if pm.all('td').size > 2
            if pm.all('td')[4].text.length > 0 || pm.all('td')[5].text.length > 0 || pm.all('td')[6].text.length > 0
              merch_name = pm.find('td.l.tl').text
              freedom << {
                merch_name: merch_name,
                value: pm.all('td')[4].text,
                link: pm.all('td')[4].find('a')[:href]
              }
              ink << {
                merch_name: merch_name,
                value: pm.all('td')[5].text,
                link: pm.all('td')[5].find('a')[:href]
              }
              sapphire << {
                merch_name: merch_name,
                value: pm.all('td')[6].text,
                link: pm.all('td')[6].find('a')[:href]
              }
              # puts freedom
              result << { freedom: freedom, ink: ink, sapphire: sapphire }
            end
          end
        end
        # puts c
        all('td.nb.b')[c.to_i].find('a').click if c < all('td.nb.b').size - 1
      end
      Capybara.reset_sessions!
      puts Time.now - t
      result
    end
  end
end
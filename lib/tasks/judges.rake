require 'open-uri'

namespace :scrape do
  desc 'Pull judges for a county'
  task judges: :environment do
    JudgesWorker.perform_async
  end
end

require 'open-uri'

# Source downloaded from:
# https://web.archive.org/web/20220000000000*/https://oklahoma.gov/doc/communications/odoc-public-inmate-data.html
# DOC publishes data quarterly retroactively for the previous quarter.
# (So on 2022-10-31 the data on the site will be from 2022-03 to 2022-06)

namespace :doc do
  desc 'Scrape DOC for most recent file and import'

  desc 'Scrape DOC for most recent file and validate'
  task :scrape, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Scrapers::Doc::QuarterlyData.perform(dir)
  end

  desc 'Scrape DOC for most recent file and import'
  task :import, [:dir] => [:environment] do |_t, args|
    dir = args.dir
    Importers::Doc::OffenseCode.new(dir).perform
    Importers::Doc::Profile.new(dir).perform
    Importers::Doc::Sentence.new(dir).perform
    Importers::Doc::ConsecutiveSentence.new(dir).perform
    Importers::Doc::Alias.new(dir).perform
    Importers::Doc::Status.new(dir).perform
  end

  desc 'Link DOC data to other datasets'
  task link: :environment do
    Importers::Doc::LinkCounties.new.perform
    Importers::Doc::LinkCases.new.perform
    Importers::Doc::LinkOffenseCodes.new.perform
  end
end

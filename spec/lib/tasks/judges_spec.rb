require 'rails_helper'
require 'rake'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe 'scrape:court_cases', type: :task do
  it 'queues up the judges scraper to pull in all judges' do
    expect do
      Rake::Task['scrape:judges'].invoke
    end.to change(JudgesWorker.jobs, :size).by(1)
  end
end

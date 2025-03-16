# Worker that updates all judges from the select dropdown
class JudgesWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform
    ::Scrapers::Judges.perform
  end
end
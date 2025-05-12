require 'sidekiq/throttled'

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

# Throttle OSCN requests during business hours
OKLAHOMA_DAY_START = Time.parse("02:00 pm UTC")
OKLAHOMA_DAY_END = Time.parse("10:00 pm UTC")
Sidekiq::Throttled::Registry.add(:oscn, **{
  threshold: {
    :limit => ->(*_) {
      Time.now.utc.between?(OKLAHOMA_DAY_START, OKLAHOMA_DAY_END) ? ENV.fetch('OSCN_THROTTLE', 60).to_i : 1_000
    },
    :period => 1.minute
  }
})

Sidekiq::Throttled::Registry.add(:tulsa_city, **{
  threshold: {
    :limit => ->(*_) {
      Time.now.utc.between?(OKLAHOMA_DAY_START, OKLAHOMA_DAY_END) ? ENV.fetch('TULSA_CITY_THROTTLE', 60).to_i : 1_000
    },
    :period => 1.minute
  }
})

Sidekiq::Throttled::Registry.add(:ok2explore, **{
  threshold: { limit: ENV.fetch('OK2EXPLORE_THROTTLE', 20).to_i, period: 1.minute },
  concurrency: { limit: ENV.fetch('OK2EXPLORE_CONCURRENCY', 3).to_i },
})

Sidekiq::Throttled::Registry.add(:eviction_ocr, **{
  threshold: { limit: 10, period: 1.minute },
  concurrency: { limit: 1 },
})

Sidekiq::Throttled::Registry.add(:crime_map_worker, **{
  threshold: { limit: 1, period: 1.minute },
  concurrency: { limit: 1 },
})

Sidekiq::Throttled.setup!

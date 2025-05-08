class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def set_time_zone(&block)
    Time.use_zone("America/Chicago", &block)
  end
end

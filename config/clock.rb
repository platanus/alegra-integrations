require 'clockwork'
require_relative './boot'
require_relative './environment'

module Clockwork
  error_handler do |error|
    Raven.capture_exception(error)
  end
  # Example
  #
  # every(5.minutes, 'ScheduledJob') do
  #   ScheduledJob.perform_later
  # end
end

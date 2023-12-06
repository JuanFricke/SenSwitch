require 'clockwork'

module Clockwork
  handler do |job|
    system("bundle exec rake #{job}")
  end

  every(5.minutes, 'sync_data:run')
end

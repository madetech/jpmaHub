require 'net/http'

namespace :scheduler do
  task :start do
    uri = URI.parse(ENV["APP_URL"])
    Net::HTTP.get(uri) if Time.now.wednesday?
  end
end
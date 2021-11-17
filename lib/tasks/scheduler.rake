namespace :scheduler do
  task :start do
    `bundle exec rackup -p 5000` if Time.now.wednesday?
  end
end
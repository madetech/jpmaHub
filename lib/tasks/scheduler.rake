namespace :scheduler do
  task :start do
    `rackup -p 5000` if Time.now.wednesday?
  end
end
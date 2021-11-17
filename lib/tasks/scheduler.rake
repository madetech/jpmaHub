namespace :scheduler do
  task :start do
    `rackup -p 5001` if Time.now.friday?
  end
end
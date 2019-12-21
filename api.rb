require './db/migrator'
require './lib/builder/tgif'
require './lib/database_admin/postgres'
require './lib/domain/tgif'
require './lib/gateway/sequel_tgif_gateway.rb'
require './lib/usecase/fetch_weekly_tgif'
require './lib/usecase/submit_tgif'
require 'json'
require 'rdiscount'
require 'sinatra'

class TgifService < Sinatra::Base
  before do
    @database = DatabaseAdministrator::Postgres.new.existing_database
    @tgif_gateway = SequelTgifGateway.new(database: @database)
    @list_weekly_tgif = FetchWeeklyTgif.new(tgif_gateway: @tgif_gateway)
  end 

  after do
    @database.disconnect
  end

  post '/delete-tgifs' do
    response = params['user_id']

    if response == ENV['AUTH_DELETE_ALL']
      @tgif_gateway.delete_all
      "TGIF deleted"
    else
      "You are not authorised to delete tgifs"
    end
  end

  post '/weekly-tgifs' do
    @tgifs = @list_weekly_tgif.execute
    erb :index
  end 

  post '/submit-tgif' do
    response =  params['text']
    team_name = response.split('|')[0]
    message = response[team_name.size+1..-1].strip

    if message.size() <= 280
      @tgif_row = { team_name: team_name, message: message }
      submit_tgif = SubmitTgif.new(tgif_gateway: @tgif_gateway)
      submit_tgif.execute(tgif: @tgif_row)

      "TGIF has successfully submitted for #{team_name}"
    else 
      "TGIF can't be submitted and has execeeded 280 characters limit"
    end 
  end 
end 
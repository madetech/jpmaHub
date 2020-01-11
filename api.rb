require 'json'
require 'rdiscount'
require 'sinatra'
require './lib/builder/tgif'
require './lib/domain/tgif'
require './lib/gateway/tgifs_gateway.rb'
require './lib/usecase/fetch_weekly_tgif'
require './lib/usecase/submit_tgif'
require './lib/usecase/delete_all_tgif'
require './lib/usecase/delete_team_tgif'
require 'sinatra/activerecord'

class TgifService < Sinatra::Base

  def initialize
    @tgif_gateway = Gateway::TgifsGateway.new
    @list_weekly_tgif = FetchWeeklyTgif.new(tgif_gateway: @tgif_gateway)
    @delete_all_tgif = DeleteAllTgif.new(tgif_gateway: @tgif_gateway)
    @delete_team_tgif = DeleteTeamTgif.new(tgif_gateway: @tgif_gateway)
    super
  end

  post '/delete-all' do
    response = params['user_id']

    if response == ENV['AUTH_DELETE_ALL']
      delete_message
    else
      "You are not authorised to delete tgifs"
    end
  end

  post '/delete-tgif' do
    response_text = params['text']
    delete_team_tgif = @delete_team_tgif.execute(response_text)[:is_deleted]
    delete_message = '*No TGIF to delete*'

    if delete_team_tgif
      delete_message = '*TGIF deleted*'
    end

    delete_message
  end

  post '/weekly-tgifs' do
    @tgifs = @list_weekly_tgif.execute
    erb :index
  end

  post '/submit-tgif' do
    response = params['text']
    split_response = response.split('|')[0]
    team_name = split_response.strip
    message = response[split_response.size + 1..-1].strip

    if message.size() <= 280
      @tgif_row = {team_name: team_name, message: message}
      submit_tgif = SubmitTgif.new(tgif_gateway: @tgif_gateway)
      submit_tgif.execute(tgif: @tgif_row)

      "TGIF has successfully submitted for #{team_name}"
    else
      "TGIF can't be submitted and has execeeded 280 characters limit"
    end
  end
end

def delete_message
  delete_all_tgif = @delete_all_tgif.execute[:is_deleted]
  delete_message = '*No TGIF to delete*'

  if delete_all_tgif
    delete_message = '*TGIFs deleted*'
  end

  delete_message
end
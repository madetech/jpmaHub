require 'json'
require 'rdiscount'
require 'sinatra'
require './lib/builder/tgif'
require './lib/container'
require './lib/domain/tgif'
require './lib/gateway/tgifs_gateway.rb'
require './lib/usecase/fetch_weekly_tgif'
require './lib/usecase/submit_tgif'
require './lib/usecase/delete_all_tgif'
require './lib/usecase/delete_team_tgif'

class TgifService < Sinatra::Base
  def initialize
    @container = Container.new
    super
  end

  post '/delete-all' do
    response = params['user_id']

    if response == ENV['AUTH_DELETE_ALL']
      delete_message
    else
      '*You are not authorised to delete tgifs*'
    end
  end

  post '/delete-tgif' do
    response_text = params['text']
    response_user_id = params['user_id']

    delete_team_tgif = @container.get_object(:delete_team_tgif)
    usecase_response = delete_team_tgif.execute(response_text, response_user_id)

    delete_message = '*No TGIF to delete*'
    if usecase_response == :tgif_deleted
      delete_message = '*TGIF deleted*'
    elsif usecase_response == :unauthorised_user
      delete_message = '*You are not authorised to delete tgifs*'
    end
    delete_message
  end

  post '/weekly-tgifs' do
    @tgifs = @container.get_object(:fetch_weekly_tgif).execute
    erb :index
  end

  post '/submit-tgif' do
    response_test = params['text']
    response_user_id = params['user_id']

    split_response = response_test.split('|')[0]
    team_name = split_response.strip
    message = response_test[split_response.size + 1..-1].strip

    if message.size() <= 280
      @tgif_row = {team_name: team_name, message: message, slack_user_id: response_user_id}
      submit_tgif = @container.get_object(:submit_tgif)
      submit_tgif.execute(tgif: @tgif_row)

      "*TGIF has successfully submitted for #{team_name}*"
    else
      "*TGIF can't be submitted and has execeeded 280 characters limit*"
    end
  end
end

def delete_message
  delete_all_tgif = @container.get_object(:delete_all_tgif)
  response = delete_all_tgif.execute[:is_deleted]

  delete_message = '*No TGIF to delete*'

  if response
    delete_message = '*TGIFs deleted*'
  end

  delete_message
end
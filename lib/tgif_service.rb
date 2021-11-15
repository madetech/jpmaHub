# frozen_string_literal: true
require 'rdiscount'
require 'sinatra'
require 'rest-client'
class TgifService < Sinatra::Base
  def initialize
    @container = Container.new
    super
  end

  post '/open-list-tgif' do
    open_tgif_modal = @container.get_object(:open_tgif_modal)

    @tgifs = @container.get_object(:fetch_weekly_tgif).execute

    modal_block = [{"type": "divider"},]

    if @tgifs.nil?
      modal_block << empty_modal_block
    else
      tgif_modal_modal(modal_block)
    end


    response = open_tgif_modal.list_modal(params['trigger_id'], modal_block)

    if response
      status 200
    else
      '*TGIF modal cannot be opened.*'
    end
  end

  post '/tgif-submit-request' do
    response = JSON.parse(params['payload'])

    slack_user_id = response['user']['id']
    team_name = response['view']['state']['values']['team_block']['content']['value']
    message = response['view']['state']['values']['message_block']['content']['value']

    @tgif_row = {team_name: team_name, message: message, slack_user_id: slack_user_id}

    submit_tgif = @container.get_object(:submit_tgif)
    submit_tgif.execute(tgif: @tgif_row)

    send_message_slack = @container.get_object(:send_message_slack)
    send_message_slack.submit_response(response['view']['private_metadata'], team_name)
    status 200
  end

  post '/tgif-open-modal' do
    open_tgif_modal = @container.get_object(:open_tgif_modal)
    response = open_tgif_modal.submit_modal(params['trigger_id'], params['channel_id'])

    if response
      status 200
    else
      '*TGIF modal cannot be opened.*'
    end
  end

  post '/help' do
    erb :help
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
    team_name = params['text']
    response_user_id = params['user_id']

    delete_team_tgif = @container.get_object(:delete_team_tgif)
    usecase_response = delete_team_tgif.execute(team_name, response_user_id)

    delete_message = '*No TGIF to delete*'
    if usecase_response == :tgif_deleted
      delete_message = "*TGIF deleted for #{team_name}*"
    elsif usecase_response == :unauthorised_user
      delete_message = '*You are not authorised to delete this tgif*'
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
      over_limit_by = message.size - 280
      "*TGIF can't be submitted*: Exceeded the maximum 280 characters limit by *#{over_limit_by} character(s)*"
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

def empty_modal_block
  {
      "type": "section",
      "text": {
          "type": "mrkdwn",
          "text": "No Tgifs yet"
      }
  }
end

def tgif_modal_modal(modal_block)
  @tgifs.each do |tgif|
    modal_block << {
        "type": "section",
        "text": {
            "type": "mrkdwn",
            "text": "*#{tgif[:team_name]}*\n #{tgif[:message]}"
        }
    }
  end

  modal_block
end

module RemoteUseCase
  class SendMessageSlack
    def submit_response(channel_id, team_name)
      url = 'https://slack.com/api/chat.postMessage'

      body = {
          "channel": channel_id,
          "text": "*TGIF has successfully submitted for #{team_name}*"
      }
      headers = {
          'Authorization' => "Bearer #{ENV['TOKEN']}",
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json'
      }

      RestClient.post(url, body.to_json, headers)
    end
  end
end
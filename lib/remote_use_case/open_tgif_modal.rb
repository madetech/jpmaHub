module RemoteUseCase
  class OpenTgifModal
    def list_modal(trigger_id, list_tgif)
      body = {
          "trigger_id": trigger_id,
          view: {
              "type": "modal",
              "title": {
                  "type": "plain_text",
                  "text": "TGIF",
                  "emoji": true
              },
              "blocks":
                  list_tgif

          }}
      headers = {
          'Authorization' => "Bearer #{ENV['TOKEN']}",
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json'
      }

      response = RestClient.post('https://slack.com/api/views.open', body.to_json, headers)
      is_successful = false

      if JSON.parse(response.body)["ok"]
        is_successful = true
      end

      is_successful
    end


    def submit_modal(trigger_id, channel_id)
      url = 'https://slack.com/api/views.open'

      body = {
          "trigger_id": trigger_id,
          view: {
              "type": "modal",
              "callback_id": "open_submit_tgif",
              "title": {
                  "type": "plain_text",
                  "text": "Submit TGIF",
                  "emoji": true
              },
              "submit": {
                  "type": "plain_text",
                  "text": "Submit",
                  "emoji": true
              },
              "close": {
                  "type": "plain_text",
                  "text": "Cancel",
                  "emoji": true
              },
              "private_metadata": channel_id,
              "blocks": [
                  {
                      "block_id": "team_block",
                      "type": "input",
                      "label": {
                          "type": "plain_text",
                          "text": "Team",
                          "emoji": true
                      },
                      "element": {
                          "action_id": "content",
                          "type": "plain_text_input",
                          "multiline": false,
                          "placeholder": {
                              "type": "plain_text",
                              "text": "Enter your team name"
                          },
                      }
                  },
                  {
                      "block_id": "message_block",
                      "type": "input",
                      "label": {
                          "type": "plain_text",
                          "text": "Message",
                          "emoji": true
                      },
                      "element": {
                          "action_id": "content",
                          "type": "plain_text_input",
                          "multiline": true,
                          "max_length": 280,
                          "placeholder": {
                              "type": "plain_text",
                              "text": "Enter your message"
                          },
                      }
                  }
              ]
          }
      }
      headers = {
          'Authorization' => "Bearer #{ENV['TOKEN']}",
          'Content-Type' => 'application/json; charset=utf-8',
          'Accept' => 'application/json'
      }

      response = RestClient.post(url, body.to_json, headers)

      is_successful = false

      if JSON.parse(response.body)["ok"]
        is_successful = true
      end

      is_successful
    end
  end
end
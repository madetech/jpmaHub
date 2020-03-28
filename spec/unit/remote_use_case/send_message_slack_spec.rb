describe RemoteUseCase::SendMessageSlack do
  context 'when the api call to post message to slack is successful' do
    let(:team_name) { 'team one' }
    let(:channel_id) {'XY64574'}
    let(:remote_use_case) { described_class.new }

    before do
      SendMessageSlack::SuccessfulStub.new.submit_response(team_name, channel_id)
    end

    it 'returns true' do
      send_message_slack = described_class.new
      response = send_message_slack.submit_response(team_name, channel_id)

      expect(JSON.parse(response.body)["ok"]).to eq(true)
    end
  end

  context 'when the api call to post message to slack is unsuccessful' do
    let(:team_name) { 'team two' }
    let(:channel_id) {'XY64574'}

    before do
      SendMessageSlack::UnsuccessfulStub.new.submit_response(team_name, channel_id)
    end

    it 'returns false' do
      send_message_slack = described_class.new
      response = send_message_slack.submit_response(team_name, channel_id)
      expect(JSON.parse(response.body)["ok"]).to eq(false)
    end
  end
end
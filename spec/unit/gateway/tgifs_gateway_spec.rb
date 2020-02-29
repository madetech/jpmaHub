describe Gateway::TgifsGateway do

  let(:tgif_gateway) { described_class.new }

  it 'can get a weekly tgifs' do
    populate_tgif('team_name_one', 'message_one', DateTime.now - 8, 'U1234')
    populate_tgif('team_name_two', 'message_two', DateTime.now + 1, 'U1234')
    populate_tgif('team_current_week', 'message', DateTime.now + 7, 'U1234')

    expect(tgif_gateway.fetch_tgif.count).to eq(1)

    tgif_gateway.fetch_tgif.first.tap do |tgif|
      expect(tgif.id).not_to be nil
      expect(tgif.team_name).to eq('team_current_week')
      expect(tgif.message).to eq('message')
    end
  end

  it 'can delete all tgifs' do
    populate_tgif('team_name_one', 'team_message_one', '11234')
    populate_tgif('team_name_two', 'team_message_two', '11234')

    expect(tgif_gateway.fetch_tgif.count).to eq(2)

    tgif_gateway.delete_all

    expect(tgif_gateway.fetch_tgif.count).to eq(0)
  end

  it 'can delete tgif by team' do
    populate_tgif('team_name', 'message', 'U1234')
    populate_tgif('team', 'message_one', 'U1234')
    populate_tgif('team', 'message_two', 'U134')

    expect(tgif_gateway.fetch_tgif.count).to eq(3)

    tgif_gateway.delete_tgif('Team', 'U1234')

    expect(tgif_gateway.fetch_tgif.count).to eq(2)
  end

  context 'when tgif exists by team' do
    it 'returns true' do
      populate_tgif('team_name_two', 'message_two', 'U1234')
      populate_tgif('team', 'message', 'U1234')

      expect(tgif_gateway.tgif_exists?('team')).to eq(true)
    end
  end
  context 'when tgif doesnt exist by team' do
    it 'returns false' do
      populate_tgif('name_two', 'message_two', 'U1234')
      populate_tgif('team', 'message_one', 'U1234')

      expect(tgif_gateway.tgif_exists?('one')).to eq(false)
    end
  end

  context 'when authorised user deletes tgif by team' do
    it 'returns true' do
      populate_tgif('team_two', 'message_two', 'U134')
      populate_tgif('team', 'message_one', 'U1234')

      expected_response = tgif_gateway.authorised_user?('team', 'U1234')

      expect(expected_response).to eq(true);
    end
  end

  context 'when unauthorised user deletes tgif by team' do
    it 'returns false' do
      populate_tgif('team_name_three', 'message_three', 'A234')
      populate_tgif('team', 'message_two', 'U1234')

      expected_response = tgif_gateway.authorised_user?('team', 'C5678')
      expect(expected_response).to eq(false);
    end
  end
end

def populate_tgif(team_name, message, time = DateTime.now, slack_user_id)
  tgif_builder = Builder::Tgif.new
  tgif_builder.build_tgif(team_name: team_name, message: message, slack_user_id: slack_user_id)
  allow(DateTime).to receive(:now).and_return(time)
  tgif_gateway.save(tgif_builder.build)
end


describe Gateway::TgifsGateway do

  let(:tgif_gateway) { described_class.new }

  it 'can get a weekly list of tgifs' do
    populate_weekly_tgif('team_name_one', 'message_one', DateTime.now - 8)
    populate_weekly_tgif('team_name_two', 'message_two', DateTime.now + 1)
    populate_weekly_tgif('team_current_week', 'message', DateTime.now + 7)

    expect(tgif_gateway.fetch_tgif.count).to eq(1)

    tgif_gateway.fetch_tgif.first.tap do |tgif|
      expect(tgif.id).not_to be nil
      expect(tgif.team_name).to eq('team_current_week')
      expect(tgif.message).to eq('message')
    end
  end

  it 'can delete all tgifs' do
    populate_tgif('team_name_one', 'message_one')
    populate_tgif('team_name_two', 'message_two')
    populate_tgif('team_current_week', 'message')

    expect(tgif_gateway.fetch_tgif.count).to eq(3);

    tgif_gateway.delete_all

    expect(tgif_gateway.fetch_tgif.count).to eq(0);
  end

  it 'can delete tgif by team' do
    populate_tgif('team_name_two', 'message_two')
    populate_tgif('team', 'message_one')

    expect(tgif_gateway.fetch_tgif.count).to eq(2);

    tgif_gateway.delete_tgif('Team')

    expect(tgif_gateway.fetch_tgif.count).to eq(1);
  end
end

def populate_weekly_tgif(team_name, message, time = nil)
  tgif_builder = Builder::Tgif.new
  tgif_builder.from(team_name: team_name, message: message)
  allow(DateTime).to receive(:now).and_return(time)
  tgif_gateway.save(tgif_builder.build)
end

def populate_tgif(team_name, message)
  tgif_builder = Builder::Tgif.new
  tgif_builder.from(team_name: team_name, message: message)
  tgif_gateway.save(tgif_builder.build)
end 
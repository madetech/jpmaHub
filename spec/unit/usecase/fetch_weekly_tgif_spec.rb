describe FetchWeeklyTgif do
  class TgifStub
    def initialize(id, team_name, message)
      @id = id
      @team_name = team_name
      @message = message
    end

    attr_reader :id, :team_name, :message, :slack_user_id
  end

  it 'returns tgifs to view by weekly' do
    team_one_tgif = {id: '1', team_name: 'teamone', message: 'message one'}
    team_two_tgif = {id: '2', team_name: 'teamtwo', message: 'message two'}
    list_weekly_tgifs = FetchWeeklyTgif.new(tgif_gateway: double(fetch_tgif: [TgifStub.new('1', 'teamone', 'message one'), TgifStub.new('2', 'teamtwo', 'message two')]))

    response = list_weekly_tgifs.execute

    expect(response[0]).to eq(team_one_tgif)
    expect(response[1]).to eq(team_two_tgif)
  end

  it 'returns nil when no tgifs to view for the week' do
    list_weekly_tgifs_details = FetchWeeklyTgif.new(tgif_gateway: double(fetch_tgif: []))
    expect(list_weekly_tgifs_details.execute).to eq(nil)
  end
end
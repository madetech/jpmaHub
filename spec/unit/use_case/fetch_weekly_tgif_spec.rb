describe UseCase::FetchWeeklyTgif do
  it 'returns tgifs when tgifs exist' do
    team_one_tgif = {id: '1', team_name: 'teamone', message: 'message one'}
    team_two_tgif = {id: '2', team_name: 'teamtwo', message: 'message two'}
    list_weekly_tgifs = described_class.new(
        tgif_gateway: double(fetch_tgif: [
            TgifStub.new('1', 'teamone', 'message one'),
            TgifStub.new('2', 'teamtwo', 'message two')
        ]))

    response = list_weekly_tgifs.execute

    expect(response[0]).to eq(team_one_tgif)
    expect(response[1]).to eq(team_two_tgif)
  end

  it 'returns nil when there are no tgifs to fetch' do
    list_weekly_tgifs_details = described_class.new(tgif_gateway: double(fetch_tgif: []))
    expect(list_weekly_tgifs_details.execute).to eq(nil)
  end
end
describe 'TGIF Service' do
  database = DatabaseAdministrator::Postgres.new.existing_database
  let(:tgif_gateway) { SequelTgifGateway.new(database: database) }

  before do
    tgif_gateway.delete_all
  end

  let(:submit_tgif) do
    SubmitTgif.new(tgif_gateway: tgif_gateway)
  end 

  let(:weekly_list_tgif) do
    FetchWeeklyTgif.new(tgif_gateway: tgif_gateway)
  end 

  it 'returns [] when no tgifs pass to gateway' do
    submit_tgif.execute(tgif: [])
    weekly_list_tgif.execute

    expect(tgif_gateway.all).to eq([])
  end

  it 'use tgif gateway to submit tgif' do
    tgif_submitted = {team_name: 'team_one', message: 'team_one_message'}
    submit_tgif.execute(tgif: tgif_submitted)

    tgif = tgif_gateway.all.first

    expect(tgif.team_name).to eq('team_one')
    expect(tgif.message).to eq('team_one_message')
  end 

  it 'uses tgif gateway to submit multiple tgif' do
    tgif_submitted_one = {team_name: 'team_one', message: 'team_one_message'}
    tgif_submitted_two = {team_name: 'team_two', message: 'team_two_message'}

    submit_tgif.execute(tgif: tgif_submitted_one)
    submit_tgif.execute(tgif: tgif_submitted_two)

    tgif = tgif_gateway.all

    expect(tgif[0].team_name).to eq('team_one')
    expect(tgif[0].message).to eq('team_one_message')

    expect(tgif[1].team_name).to eq('team_two')
    expect(tgif[1].message).to eq('team_two_message')
  end

  it 'uses tgif gateway to fetch tgif by weekly' do
    team1_tgif_details = {team_name: 'teamOne_last_week', message: 'team_one_message'}
    team2_tgif_details = {team_name: 'teamTwo_current_week', message: 'team_two_message'}
    team3_tgif_details = {team_name: 'teamThree_current_week', message: 'team_three_message'}

    # last week tgifs
    allow(DateTime).to receive(:now).and_return(DateTime.now-7)
    submit_tgif.execute(tgif: team1_tgif_details)

    # current week tgifs
    allow(DateTime).to receive(:now).and_return(DateTime.now+6)
    submit_tgif.execute(tgif: team2_tgif_details)
    submit_tgif.execute(tgif: team3_tgif_details)
   
    weekly_list_tgif.execute
    
    expect(tgif_gateway.fetch_tgif.count).to eq(2)

    tgif_gateway.fetch_tgif.tap do |tgif|
      expect(tgif[0].id).not_to be nil
      expect(tgif[0].team_name).to eq('teamTwo_current_week')
      expect(tgif[0].message).to eq('team_two_message')

      expect(tgif[1].id).not_to be nil
      expect(tgif[1].team_name).to eq('teamThree_current_week')
      expect(tgif[1].message).to eq('team_three_message')
    end  
  end 
end

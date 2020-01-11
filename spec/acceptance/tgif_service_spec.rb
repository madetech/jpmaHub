describe 'TGIF Service' do
  let(:tgif_gateway) { Gateway::TgifsGateway.new }

  let(:submit_tgif) do
    SubmitTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:weekly_list_tgif) do
    FetchWeeklyTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:delete_all_tgif) do
    DeleteAllTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:delete_team_tgif) do
    DeleteTeamTgif.new(tgif_gateway: tgif_gateway)
  end

  context 'submit tgif' do
    it 'use tgif gateway to submit tgif' do
      tgif_submitted = {team_name: 'team_one', message: 'team_one_message'}
      submit_tgif.execute(tgif: tgif_submitted)

      tgif = tgif_gateway.fetch_tgif.first

      expect(tgif.team_name).to eq('team_one')
      expect(tgif.message).to eq('team_one_message')
    end

    it 'uses tgif gateway to submit multiple tgif' do
      tgif_submitted_one = {team_name: 'team_one', message: 'team_one_message'}
      tgif_submitted_two = {team_name: 'team_two', message: 'team_two_message'}

      submit_tgif.execute(tgif: tgif_submitted_one)
      submit_tgif.execute(tgif: tgif_submitted_two)

      tgif = tgif_gateway.fetch_tgif

      expect(tgif[0].team_name).to eq('team_one')
      expect(tgif[0].message).to eq('team_one_message')

      expect(tgif[1].team_name).to eq('team_two')
      expect(tgif[1].message).to eq('team_two_message')
    end

  end

  context 'fetch tgif' do
    it 'uses tgif gateway to fetch tgif by weekly' do
      team1_tgif_details = {team_name: 'teamOne_last_week', message: 'team_one_message'}
      team2_tgif_details = {team_name: 'teamTwo_current_week', message: 'team_two_message'}
      team3_tgif_details = {team_name: 'teamThree_current_week', message: 'team_three_message'}

      # last week tgifs
      allow(DateTime).to receive(:now).and_return(DateTime.now - 7)
      submit_tgif.execute(tgif: team1_tgif_details)

      # current week tgifs
      allow(DateTime).to receive(:now).and_return(DateTime.now + 6)
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

  context 'delete all tgif' do
    it 'uses tgif gateway to delete all tgif' do
      team1_tgif_details = {team_name: 'teamOne', message: 'team_one_message'}
      team2_tgif_details = {team_name: 'teamTwo', message: 'team_two_message'}

      submit_tgif.execute(tgif: team1_tgif_details)
      submit_tgif.execute(tgif: team2_tgif_details)

      weekly_list_tgif.execute

      expect(tgif_gateway.fetch_tgif.count).to eq(2)

      delete_all_tgif.execute

      expect(tgif_gateway.fetch_tgif.count).to eq(0)
    end
  end

  context 'delete team tgif' do

    it 'uses tgif gateway to delete tgif by team' do
      team1_tgif_details = {team_name: 'teamOne', message: 'team_one_message'}
      team2_tgif_details = {team_name: 'teamTwo', message: 'team_two_message'}

      submit_tgif.execute(tgif: team1_tgif_details)
      submit_tgif.execute(tgif: team2_tgif_details)

      weekly_list_tgif.execute

      expect(tgif_gateway.fetch_tgif.count).to eq(2)

      delete_team_tgif.execute('teamTwo')

      expect(tgif_gateway.fetch_tgif.count).to eq(1)
    end
  end
end

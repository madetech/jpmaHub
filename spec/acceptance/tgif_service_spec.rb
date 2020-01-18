describe 'TGIF Service' do
  let(:tgif_gateway) { Gateway::TgifsGateway.new }

  let(:submit_tgif) do
    UseCase::SubmitTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:weekly_list_tgif) do
    UseCase::FetchWeeklyTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:delete_all_tgif) do
    UseCase::DeleteAllTgif.new(tgif_gateway: tgif_gateway)
  end

  let(:delete_team_tgif) do
    UseCase::DeleteTeamTgif.new(tgif_gateway: tgif_gateway)
  end

  def submit_tgifs
    team1_tgif_details = {team_name: 'teamOne', message: 'team_one_message', slack_user_id: 'UA34'}
    team2_tgif_details = {team_name: 'teamTwo', message: 'team_two_message', slack_user_id: 'U34'}

    submit_tgif.execute(tgif: team1_tgif_details)
    submit_tgif.execute(tgif: team2_tgif_details)
  end

  context 'submit tgif' do
    it 'uses tgif gateway to submit tgif' do
      tgif_submitted = {team_name: 'team_one', message: 'team_one_message'}
      submit_tgif.execute(tgif: tgif_submitted)

      tgif = tgif_gateway.fetch_tgif.first

      expect(tgif.team_name).to eq('team_one')
      expect(tgif.message).to eq('team_one_message')
    end

    it 'uses tgif gateway to submit multiple tgifs' do
      submit_tgifs

      tgif = tgif_gateway.fetch_tgif

      expect(tgif[0].team_name).to eq('teamOne')
      expect(tgif[0].message).to eq('team_one_message')

      expect(tgif[1].team_name).to eq('teamTwo')
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

  context 'delete all tgifs' do
    context 'when authorised user deletes all tgifs' do
      context 'which exists' do
        it 'deletes all tgif' do
          submit_tgifs

          weekly_list_tgif.execute

          expect(tgif_gateway.fetch_tgif.count).to eq(2)

          delete_all_tgif.execute

          expect(tgif_gateway.fetch_tgif.count).to eq(0)
        end

        it 'returns is_deleted response true' do
          submit_tgifs

          weekly_list_tgif.execute

          expect(tgif_gateway.fetch_tgif.count).to eq(2)

          response = delete_all_tgif.execute

          expect(response[:is_deleted]).to eq(true)
        end
      end

      context 'which doesnt exists' do
        it 'returns is_deleted response false' do
          expect(delete_all_tgif.execute[:is_deleted]).to eq(false)
        end
      end
    end
  end

  context 'delete team tgif' do
    context 'when authorised user deletes tgif by team' do
      it 'uses tgif gateway to delete tgif by team' do
        submit_tgifs

        weekly_list_tgif.execute

        expect(tgif_gateway.fetch_tgif.count).to eq(2)

        delete_team_tgif.execute('teamTwo', 'U34')

        expect(tgif_gateway.fetch_tgif.count).to eq(1)
      end

      it 'returns tgif_deleted' do
        submit_tgifs

        weekly_list_tgif.execute

        expect(tgif_gateway.fetch_tgif.count).to eq(2)

        expected_response = delete_team_tgif.execute('teamTwo', 'U34')

        expect(expected_response).to eq(:tgif_deleted)
      end
    end

    context 'when unauthorised user deletes tgif by team' do
      it 'doesnt delete tgif' do
        submit_tgifs

        weekly_list_tgif.execute

        expect(tgif_gateway.fetch_tgif.count).to eq(2)

        delete_team_tgif.execute('teamTwo', 'A134')

        expect(tgif_gateway.fetch_tgif.count).to eq(2)
      end

      it 'returns :unauthorised_user' do
        submit_tgifs

        weekly_list_tgif.execute

        expect(tgif_gateway.fetch_tgif.count).to eq(2)

        expected_response = delete_team_tgif.execute('teamTwo', 'A134')

        expect(expected_response).to eq(:unauthorised_user)
      end
    end

    context 'when tgif doesnt exist' do
      it 'returns no_tgif_found' do
        submit_tgifs

        weekly_list_tgif.execute

        expect(tgif_gateway.fetch_tgif.count).to eq(2)

        expected_response = delete_team_tgif.execute('team', 'A134')
        expect(expected_response).to eq(:no_tgif_found)
      end
    end
  end
end


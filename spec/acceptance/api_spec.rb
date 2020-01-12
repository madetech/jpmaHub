describe TgifService, :type => :feature do
  describe 'the server having started' do
    context 'responses from /delete-all' do
      context 'given authorised user id with no tgif to delete' do
        let(:response) { post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL'] }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'deletes tgifs successfully' do
          expect(response.body).to include('No TGIF to delete')
        end
      end

      context 'given authorised user id with tgifs to delete' do
        context 'given delete all tgif' do
          let(:response) do
            post '/submit-tgif', { :text => 'team | message one', :user_id => '1234' }
            post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL']
          end

          it 'returns status 200' do
            expect(response.status).to eq(200)
          end

          it 'deletes tgifs successfully' do
            expect(response.body).to include('TGIFs deleted')
          end
        end

        context 'given list tgif' do
          let(:response) do
            post '/submit-tgif', :text => 'team | message one'
            post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL']
            post '/weekly-tgifs'
          end

          it 'has deleted tgif successfully' do
            expect(response.body).to include('No Tgifs yet')
          end
        end
      end

      context 'given unauthorised user id' do
        let(:response) { post '/delete-all', :user_id => 'nil' }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'cannot delete tgif' do
          expect(response.body).to include('You are not authorised to delete tgifs')
        end
      end
    end

    context 'responses from /delete-tgif' do
      context 'given tgif does not exist' do
        let(:response) do
          post '/delete-tgif', { :text => 'Team', :user_id => '1234' }
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns no tgif to delete' do
          expect(response.body).to include('No TGIF to delete')
        end
      end

      context 'given authorised user to delete tgif' do
        let(:response) do
          post '/submit-tgif', { :text => 'team | message one', :user_id => '1234' }
          post '/delete-tgif', { :text => 'Team', :user_id => '1234' }
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'deletes tgif successfully' do
          expect(response.body).to include('TGIF deleted')
        end
      end

      context 'given unauthorised user to delete tgif' do
        let(:response) do
          post '/submit-tgif', { :text => 'team | message one', :user_id => '134' }
          post '/delete-tgif', { :text => 'Team', :user_id => '1234' }
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'doesnt delete tgif' do
          expect(response.body).to include('You are not authorised to delete tgifs')
        end
      end
    end

    context 'responses from /weekly-tgifs' do
      context 'when there is tgif submitted' do
        let(:response) do
          post '/submit-tgif', { :text => 'Team weekly | message one', :user_id => '134' }
          post '/weekly-tgifs'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns team name' do
          expect(response.body).to include('Team weekly')
        end
      end

      context 'when there is no tgif submitted' do
        let(:response) do
          post '/weekly-tgifs'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns no tgifs' do
          expect(response.body).to include('No Tgifs yet')
        end
      end
    end

    context 'responses from /submit-tgif ' do
      context 'when submitted tgif exceed 280 character limit' do
        let(:response) { post '/submit-tgif', { :text => 'Team one | message one', :user_id => '134' } }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'submits TGIF' do
          expect(response.body).to include('TGIF has successfully submitted for Team one')
        end
      end

      context 'when submitted tgif execeed 280 character limit' do
        let(:response) do
          tgif_message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' +
              'Mauris id lorem et diam luctus blandit. Interdum et malesuada fames ac ' +
              'ante ipsum primis in faucibus. Vivamus egestas felis ipsum, in tempus purus ' +
              'porta at.Lorem ipsum dolor sit amet, consectetur adipiscing elit.adipiscinnn.'
          post '/submit-tgif', { :text => "Team one | #{tgif_message}", :user_id => '134' }
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'cannot submit TGIF' do
          expect(response.body).to include('TGIF can\'t be submitted and has execeeded 280 characters limit')
        end
      end
    end
  end
end 
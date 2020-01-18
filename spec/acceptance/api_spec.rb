describe 'Acceptance::TgifService' do
  describe '.post /delete-all' do
    context 'when authorised user deletes all tgifs' do
      context 'which doesnt exist' do
        let(:response) { post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL'] }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns no tgif to delete' do
          expect(response.body).to include('No TGIF to delete')
        end
      end

      context 'which exists' do
        context 'delete tgifs' do
          let(:response) do
            post '/submit-tgif', {:text => 'team | message one', :user_id => '1234'}
            post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL']
          end

          it 'returns status 200' do
            expect(response.status).to eq(200)
          end

          it 'returns TGIFs deleted' do
            expect(response.body).to include('TGIFs deleted')
          end

          context 'when listing tgifs' do
            let(:response) do
              post '/submit-tgif', :text => 'team | message one'
              post '/delete-all', :user_id => ENV['AUTH_DELETE_ALL']
              post '/weekly-tgifs'
            end

            it 'returns no tgifs yet' do
              expect(response.body).to include('No Tgifs yet')
            end
          end
        end
      end
    end

    context 'when unauthorised user deletes all tgifs' do
      let(:response) { post '/delete-all', :user_id => 'nil' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'cannot delete tgif' do
        expect(response.body).to include('You are not authorised to delete tgifs')
      end
    end
  end

  describe '.post /delete-tgif' do
    context 'when tgif doesnt exist' do
      let(:response) do
        post '/delete-tgif', {:text => 'Team', :user_id => '1234'}
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns no tgif to delete' do
        expect(response.body).to include('No TGIF to delete')
      end
    end


    context 'when authorised user deletes tgif that exists' do
      let(:response) do
        post '/submit-tgif', {:text => 'team | message one', :user_id => '1234'}
        post '/delete-tgif', {:text => 'Team', :user_id => '1234'}
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns tgif deleted' do
        expect(response.body).to include('TGIF deleted')
      end
    end

    context 'when unauthorised user deletes tgif that exists' do
      let(:response) do
        post '/submit-tgif', {:text => 'team | message one', :user_id => '134'}
        post '/delete-tgif', {:text => 'Team', :user_id => '1234'}
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'doesnt delete tgif' do
        expect(response.body).to include('You are not authorised to delete tgifs')
      end
    end

  end

  describe '.post /weekly-tgifs' do
    context 'when tgif exists' do
      let(:response) do
        post '/submit-tgif', {:text => 'Team weekly | message one', :user_id => '134'}
        post '/weekly-tgifs'
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns team name' do
        expect(response.body).to include('Team weekly')
      end
    end

    context 'when tgif doesnt exist' do
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

  describe '.post /submit-tgif' do
    context 'when submits tgif under 280 character limit' do
      let(:response) { post '/submit-tgif', {:text => 'Team one | message one', :user_id => '134'} }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'submits TGIF' do
        expect(response.body).to include('TGIF has successfully submitted for Team one')
      end
    end

    context 'when submits tgif over 280 character limit' do
      let(:response) do
        tgif_message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' +
            'Mauris id lorem et diam luctus blandit. Interdum et malesuada fames ac ' +
            'ante ipsum primis in faucibus. Vivamus egestas felis ipsum, in tempus purus ' +
            'porta at.Lorem ipsum dolor sit amet, consectetur adipiscing elit.adipiscinnn.'
        post '/submit-tgif', {:text => "Team one | #{tgif_message}", :user_id => '134'}
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'cannot submit TGIF' do
        tgif_response = "*TGIF can't be submitted*: Exceeded the maximum 280 characters limit by *1 character(s)*"
        expect(response.body).to include(tgif_response)
      end
    end
  end
end 
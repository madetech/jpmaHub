describe RemoteUseCase::OpenTgifModal do

  context 'submit tgif' do
    context 'when the api call to open slack modal is successful' do
      let(:trigger_id) { '9x6284843y43' }
      let(:channel_id) { 'XY64574' }
      let(:remote_use_case) { described_class.new }

      before do
        OpenTgifModal::SuccessfulStub.new.submit_modal(trigger_id, channel_id)
      end

      it 'returns true' do
        open_tgif_modal = described_class.new
        response = open_tgif_modal.submit_modal(trigger_id, channel_id)

        expect(response).to eq(true)
      end
    end

    context 'when the api call to open slack modal is unsuccessful' do
      let(:trigger_id) { '4843y43' }
      let(:channel_id) { 'DY64574' }
      before do
        OpenTgifModal::UnsuccessfulStub.new.submit_modal(trigger_id, channel_id)
      end

      it 'returns false' do
        open_tgif_modal = described_class.new
        response = open_tgif_modal.submit_modal(trigger_id, channel_id)

        expect(response).to eq(false)
      end
    end

  end

  context 'list tgif' do
    context 'when the api call to open slack modal is successful' do
      let(:remote_use_case) { described_class.new }
      let(:trigger_id) { '9x6284843y43' }
      let(:list_tgif) do
        [{"type": "divider"}, {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Team one*\n team message}"
            }
        }, {
             "type": "section",
             "text": {
                 "type": "mrkdwn",
                 "text": "*Team two*\n team message}"
             }
         }]
      end

      before do
        OpenTgifModal::SuccessfulStub.new.list_modal(trigger_id, list_tgif)
      end

      it 'returns true' do
        open_tgif_modal = described_class.new
        response = open_tgif_modal.list_modal(trigger_id, list_tgif)

        expect(response).to eq(true)
      end
    end

    context 'when the api call to open slack modal is unsuccessful' do
      let(:remote_use_case) { described_class.new }
      let(:trigger_id) { '9x6284843y43' }
      let(:list_tgif) do
        [{"type": "divider"}, {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*Team one*\n team message}"
            }
        }]
      end
      before do
        OpenTgifModal::UnsuccessfulStub.new.list_modal(trigger_id, list_tgif)
      end

      it 'returns false' do
        open_tgif_modal = described_class.new
        response = open_tgif_modal.list_modal(trigger_id, list_tgif)
        expect(response).to eq(false)
      end
    end

  end
end
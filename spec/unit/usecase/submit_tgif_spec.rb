describe UseCase::SubmitTgif do
  let(:tgif_gateway) { spy(all: []) }
  let(:use_case) { described_class.new(tgif_gateway: tgif_gateway) }

  it 'uses the tgif gateway to submit tgif details' do
    tgif_details = {team_name: 'teamone', message: 'we done it'}
    use_case.execute(tgif: tgif_details)
    expect(tgif_gateway).to have_received(:save) do |tgif|
      expect(tgif.team_name).to eq('teamone')
      expect(tgif.message).to eq('we done it')
    end
  end

  it 'returns an error for empty tgif details' do
    response = use_case.execute(tgif: {})
    expect(response).to eq(successful: false, error: "no tgif to submit")
  end
end 
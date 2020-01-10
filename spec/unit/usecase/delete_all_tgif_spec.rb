describe DeleteAllTgif do
  class TgifStub
    def initialize(id, team_name, message)
      @id = id
      @team_name = team_name
      @message = message
    end

    attr_reader :id, :team_name, :message
  end

  it 'uses the tgif gateway to delete tgifs' do
    tgif_gateway = spy(fetch_tgif: [TgifStub.new('1', 'teamone', 'message one'),
                                    TgifStub.new('2', 'teamtwo', 'message two')])

    use_case = described_class.new(tgif_gateway: tgif_gateway)
    response = use_case.execute

    expect(tgif_gateway).to have_received(:delete_all)
    expect(response[:isDeleted]).to eq(true)
  end

  it 'returns false when tgifs empty' do
    use_case = described_class.new(tgif_gateway: double(fetch_tgif: []))
    response = use_case.execute
    expect(response[:isDeleted]).to eq(false)
  end
end 
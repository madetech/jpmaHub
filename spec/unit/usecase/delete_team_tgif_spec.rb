describe UseCase::DeleteTeamTgif do
  class TgifStub
    def initialize(id, team_name, message)
      @id = id
      @team_name = team_name
      @message = message
    end

    attr_reader :id, :team_name, :message
  end

  it 'uses the tgif gateway to delete tgif by team' do
    use_case = described_class.new(tgif_gateway: double(delete_tgif: 1))
    response = use_case.execute('teamone')

    expect(response[:is_deleted]).to eq(true)
  end

  it 'returns false when no tgif to delete' do
    use_case = described_class.new(tgif_gateway: double(delete_tgif: 0))
    response = use_case.execute('teamone')

    expect(response[:is_deleted]).to eq(false)
  end
end 
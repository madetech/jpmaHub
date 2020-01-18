describe UseCase::DeleteTeamTgif do
  it 'uses the tgif gateway to delete tgif by team' do
    tgif_stub = double(authorised_user?: true, tgif_exists?: true, delete_tgif: 0)
    use_case = described_class.new(tgif_gateway: tgif_stub)
    response = use_case.execute('teamone', 'UF12')

    expect(response).to eq(:tgif_deleted)
  end

  it 'returns unauthorised_user when the user is not authorised to delete' do
    tgif_stub = double(authorised_user?: false, tgif_exists?: true)
    use_case = described_class.new(tgif_gateway: tgif_stub)
    response = use_case.execute('teamone', 'UF22')

    expect(response).to eq(:unauthorised_user)
  end

  it 'returns no_tgif_found when no tgif to delete' do
    tgif_stub = double(tgif_exists?: false)
    use_case = described_class.new(tgif_gateway: tgif_stub)
    response = use_case.execute('team', 'UF22')

    expect(response).to eq(:no_tgif_found)
  end
end 
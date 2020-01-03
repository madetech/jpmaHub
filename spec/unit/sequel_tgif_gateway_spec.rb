describe SequelTgifGateway do
  database = DatabaseAdministrator::Postgres.new.existing_database
  let(:sequel_tgif_gateway) { described_class.new(database: database) }

  before do
    sequel_tgif_gateway.delete_all
  end

  it 'can get no tgifs' do
    expect(sequel_tgif_gateway.all).to eq([])
  end

  it 'can get a list of tgifs' do
    tgif_builder = Builder::Tgif.new
    tgif_builder.from(team_name: 'TeamOne', message: 'team-one-message')

    tgifs = tgif_builder.build
   
    sequel_tgif_gateway.save(tgifs)
    
    sequel_tgif_gateway.all.first.tap do |tgif|
      expect(tgif.id).not_to be nil
      expect(tgif.team_name).to eq('TeamOne')
      expect(tgif.message).to eq('team-one-message')
    end
  end 

  it 'can get a weekly list of tgifs' do
    populate_weekly_tgif('team_name_one' , 'message_one', DateTime.now-8)
    populate_weekly_tgif('team_name_two' , 'message_two', DateTime.now+1)
    populate_weekly_tgif('team_current_week' , 'message', DateTime.now+7)
   
    expect(sequel_tgif_gateway.fetch_tgif.count).to eq(1)

    sequel_tgif_gateway.fetch_tgif.first.tap do |tgif|
      expect(tgif.id).not_to be nil
      expect(tgif.team_name).to eq('team_current_week')
      expect(tgif.message).to eq('message')
    end
  end 

  it 'can delete all tgifs' do
    populate_tgif('team_name_one' , 'message_one')
    populate_tgif('team_name_two' , 'message_two')
    populate_tgif('team_current_week' , 'message')

    expect(sequel_tgif_gateway.all.count).to eq(3);

    sequel_tgif_gateway.delete_all

    expect(sequel_tgif_gateway.all.count).to eq(0);
  end 

  it 'can delete tgif by team' do
    populate_tgif('team_name_two' , 'message_two')
    populate_tgif('team' , 'message_one')

    expect(sequel_tgif_gateway.all.count).to eq(2);

    sequel_tgif_gateway.delete_tgif('team')

    expect(sequel_tgif_gateway.all.count).to eq(1);
  end 
end

def populate_weekly_tgif(team_name , message, time=nil)
  tgif_builder = Builder::Tgif.new 
  tgif_builder.from(team_name: team_name, message: message)
  tgifs = tgif_builder.build
  allow(DateTime).to receive(:now).and_return(time)
  sequel_tgif_gateway.save(tgifs)
end 

def populate_tgif(team_name , message)
  tgif_builder = Builder::Tgif.new 
  tgif_builder.from(team_name: team_name, message: message)
  tgifs = tgif_builder.build
  sequel_tgif_gateway.save(tgifs)
end 
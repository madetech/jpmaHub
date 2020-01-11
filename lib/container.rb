require './lib/gateway/tgifs_gateway.rb'
require './lib/usecase/fetch_weekly_tgif'
require './lib/usecase/submit_tgif'
require './lib/usecase/delete_all_tgif'
require './lib/usecase/delete_team_tgif'

class Container
  def initialize
    tgif_gateway = Gateway::TgifsGateway.new
    fetch_weekly_tgif = FetchWeeklyTgif.new(tgif_gateway: tgif_gateway)
    delete_all_tgif = DeleteAllTgif.new(tgif_gateway: tgif_gateway)
    delete_team_tgif = DeleteTeamTgif.new(tgif_gateway: tgif_gateway)
    submit_tgif = SubmitTgif.new(tgif_gateway: tgif_gateway)

    @objects = {
        fetch_weekly_tgif: fetch_weekly_tgif,
        delete_all_tgif: delete_all_tgif,
        delete_team_tgif: delete_team_tgif,
        submit_tgif: submit_tgif
    }
  end

  def get_object(key)
    @objects[key]
  end
end
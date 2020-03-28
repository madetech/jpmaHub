class Container
  def initialize
    tgif_gateway = Gateway::TgifsGateway.new
    delete_all_tgif = UseCase::DeleteAllTgif.new(tgif_gateway: tgif_gateway)
    delete_team_tgif = UseCase::DeleteTeamTgif.new(tgif_gateway: tgif_gateway)
    fetch_weekly_tgif = UseCase::FetchWeeklyTgif.new(tgif_gateway: tgif_gateway)
    submit_tgif = UseCase::SubmitTgif.new(tgif_gateway: tgif_gateway)

    @objects = {
        fetch_weekly_tgif: fetch_weekly_tgif,
        delete_all_tgif: delete_all_tgif,
        delete_team_tgif: delete_team_tgif,
        submit_tgif: submit_tgif,
        open_tgif_modal: RemoteUseCase::OpenTgifModal.new,
        send_message_slack: RemoteUseCase::SendMessageSlack.new
    }
  end

  def get_object(key)
    @objects[key]
  end
end
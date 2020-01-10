class DeleteTeamTgif
  def initialize(tgif_gateway: tgif_gateway)
    @tgif_gateway = tgif_gateway
  end

  def execute(team_name)
    response = {is_deleted: false}

    unless tgif_delete?(team_name)
      response = {is_deleted: true}
    end

    response
  end

  private

  def tgif_delete?(team_name)
    @tgif_gateway.delete_tgif(team_name).zero?
  end
end
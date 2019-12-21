class FetchWeeklyTgif
  def initialize(tgif_gateway: tgif_gateway)
    @tgif_gateway = tgif_gateway
  end

  def execute
    return nil if @tgif_gateway.fetch_tgif.empty?

    tgifs = @tgif_gateway.fetch_tgif

    tgifs.map! do |tgif|
      {
        id: tgif.id,
        team_name: tgif.team_name,
        message: tgif.message,
      }
    end
    tgifs
  end
end

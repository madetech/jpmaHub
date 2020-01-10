class DeleteAllTgif
  def initialize(tgif_gateway: tgif_gateway)
    @tgif_gateway = tgif_gateway
  end

  def execute
    response = {isDeleted: false}

    unless @tgif_gateway.fetch_tgif.empty?
      @tgif_gateway.delete_all
      response = {isDeleted: true}
    end

    response
  end
end 
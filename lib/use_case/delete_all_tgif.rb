module UseCase
  class DeleteAllTgif
    def initialize(tgif_gateway:)
      @tgif_gateway = tgif_gateway
    end

    def execute
      response = {is_deleted: false}

      unless @tgif_gateway.fetch_tgif.empty?
        @tgif_gateway.delete_all
        response = {is_deleted: true}
      end

      response
    end
  end
end
module UseCase
  class SubmitTgif
    def initialize(tgif_gateway:)
      @tgif_gateway = tgif_gateway
    end

    def execute(tgif:)
      @tgif = tgif

      return {"successful": false, "error": "no tgif to submit"} if @tgif.empty?

      tgif_builder = Builder::Tgif.new
      tgif_builder.tgif_details = @tgif

      @tgif_gateway.save(tgif_builder.build)

      {successful: true, errors: []}
    end
  end
end



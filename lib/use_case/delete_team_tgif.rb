module UseCase
  class DeleteTeamTgif
    def initialize(tgif_gateway:)
      @tgif_gateway = tgif_gateway
    end

    def execute(team_name, response_user_id)
      response = :no_tgif_found
      if is_tgif_exists?(team_name)
        if is_authorised_user?(team_name, response_user_id)
          @tgif_gateway.delete_tgif(team_name, response_user_id)
          response = :tgif_deleted
        else
          response = :unauthorised_user
        end
      end
      response
    end

    private

    def is_tgif_exists?(team_name)
      @tgif_gateway.tgif_exists?(team_name)
    end

    def is_authorised_user?(team_name, response_user_id)
      @tgif_gateway.authorised_user?(team_name, response_user_id)
    end
  end
end
require 'sinatra/activerecord'

module Gateway
  class TgifsGateway
    class Tgif < ActiveRecord::Base;
    end

    def fetch_tgif
      weekly_time_range = (6.days.ago..DateTime.now)
      tgifs = Tgif.where(:created_at => weekly_time_range)

      return [] if tgifs.empty?

      tgifs.map do |tgif_details|
        tgif_builder = Builder::Tgif.new
        tgif_builder.from(
            id: tgif_details[:id],
            team_name: tgif_details[:team_name],
            message: tgif_details[:message]
        )
        tgif_builder.build
      end
    end

    def save(tgif)
      serialised_tgif = {
          team_name: tgif.team_name,
          message: tgif.message,
          created_at: DateTime.now,
          slack_user_id: tgif.slack_user_id,
      }

      Tgif.create(serialised_tgif)
    end

    def delete_all
      Tgif.delete_all
    end

    def delete_tgif(team_name, slack_user_id)
      Tgif.delete_by('lower(team_name) = ? and lower(slack_user_id) = ?', team_name.downcase, slack_user_id.downcase)
    end

    def tgif_exists?(team_name)
      Tgif.where('lower(team_name) = ?', team_name.downcase).exists?
    end

    def authorised_user?(team_name, slack_user_id)
      Tgif.where("lower(team_name) = ? and lower(slack_user_id) = ?", team_name.downcase, slack_user_id.downcase).exists?
    end
  end
end
# frozen_string_literal: true
require 'json'
require 'date'

class SequelTgifGateway
  def initialize(database:)
    @database = database
  end

  def fetch_tgif
    tgifs = @database[:tgif].where { |d| d.time_stamp > DateTime.now - 6 }

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

  def all
    tgifs = @database[:tgif].all

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
      time_stamp: DateTime.now
    }

    @database[:tgif].insert(serialised_tgif)
  end

  def delete_all
    @database[:tgif].delete
  end
end 

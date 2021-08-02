module V1
  class AnnouncementsController < ApplicationController
    def create
      announcement = Announcement.create!(create_params)

      render json: announcement, status: 201
    end

    def index
      announcements = Announcement.all
      render json: announcements
    end

    private

    def create_params
      params.require(:announcement).permit(:title, :description, :price_cents, :photo)
    end
  end
end

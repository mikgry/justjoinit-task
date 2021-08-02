class AnnouncementSerializer < ActiveModel::Serializer
  attributes :title, :description, :price_cents, :photo_url

  def photo_url
    Rails.application.routes.url_helpers.rails_blob_url(@object.photo)
  end
end

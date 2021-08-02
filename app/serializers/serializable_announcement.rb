class SerializableAnnouncement < JSONAPI::Serializable::Resource
  type 'announcements'

  attributes :title, :description, :price_cents

  attribute :photo_url do
    Rails.application.routes.url_helpers.rails_blob_url(@object.photo)
  end
end

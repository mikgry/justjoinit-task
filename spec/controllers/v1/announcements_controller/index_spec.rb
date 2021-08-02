require 'rails_helper'

describe V1::AnnouncementsController do
  describe '#index' do
    subject { get :index }

    let!(:announcement_1) { create(:announcement) }
    let!(:announcement_2) { create(:announcement) }

    it 'returns a JSON response' do
      subject
      announcement = Announcement.last
      expect(JSON.parse(response.body)).to eql(
        "data" => [
          {
            "attributes"=>{
              "description"=>announcement_1.description,
              "photo-url"=>Rails.application.routes.url_helpers.rails_blob_url(announcement_1.photo),
              "price-cents"=>announcement_1.price_cents,
              "title"=>announcement_1.title
            },
            "id"=>announcement_1.id.to_s,
            "type"=>"announcements"},
          {
            "attributes"=>{
              "description"=>announcement_2.description,
              "photo-url"=>Rails.application.routes.url_helpers.rails_blob_url(announcement_2.photo),
              "price-cents"=>announcement_2.price_cents,
              "title"=>announcement_2.title
            },
            "id"=>announcement_2.id.to_s,
            "type"=>"announcements"}
        ]
      )
    end
  end
end

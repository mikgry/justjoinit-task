require 'rails_helper'

describe V1::AnnouncementsController do
  describe 'POST /v1/announcements' do
    subject { post :create, params: params }

    let(:params) do
      { announcement: { title: title, description: description,
        price_cents: price_cents, photo: photo } }
    end
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:price_cents) { 1000000 }
    let(:photo) { fixture_file_upload('photo.jpeg') }

    it 'returns status created' do
      subject
      expect(response).to have_http_status :created
    end

    it 'returns a JSON response' do
      subject
      announcement = Announcement.last
      expect(JSON.parse(response.body)).to eql(
        "data" => {
          "attributes" => {
            "description" => description,
            "photo_url" => Rails.application.routes.url_helpers.rails_blob_url(announcement.photo),
            "price_cents" => price_cents,
            "title" => title},
            "id" => announcement.id.to_s,
            "type" => "announcements"},
       "jsonapi" => {"version"=>"1.0"}
      )
    end

    it 'creates an announcement' do
      expect { subject }.to change { Announcement.count }.from(0).to(1)
    end

    it 'creates a blob ' do
      expect { subject }.to change { ActiveStorage::Blob.count }.from(0).to(1)
    end
  end
end

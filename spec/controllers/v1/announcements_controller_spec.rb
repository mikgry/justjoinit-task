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
            "photo-url" => Rails.application.routes.url_helpers.rails_blob_url(announcement.photo),
            "price-cents" => price_cents,
            "title" => title},
            "id" => announcement.id.to_s,
            "type" => "announcements"}
      )
    end

    it 'creates an announcement' do
      expect { subject }.to change { Announcement.count }.from(0).to(1)
    end

    it 'creates a blob ' do
      expect { subject }.to change { ActiveStorage::Blob.count }.from(0).to(1)
    end

    context 'missing title param' do
      let(:title) { nil }

      it 'returns status 422' do
        subject
        expect(response).to have_http_status 422
      end

      it 'returns error' do
        subject

        expect(JSON.parse(response.body)).to eql(
          { "error" => {"title"=>["can't be blank"]} }
        )
      end
    end

    context 'missing description param' do
      let(:description) { nil }

      it 'returns status 422' do
        subject
        expect(response).to have_http_status 422
      end

      it 'returns error' do
        subject

        expect(JSON.parse(response.body)).to eql(
          { "error" => {"description"=>["can't be blank"]} }
        )
      end
    end

    context 'wrong price_cents' do
      let(:price_cents) { -1 }

      it 'returns status 422' do
        subject
        expect(response).to have_http_status 422
      end

      it 'returns error' do
        subject

        expect(JSON.parse(response.body)).to eql(
         { "error" => {"price_cents"=>["must be greater than 0"]} }
        )
      end
    end
  end
end

require 'rails_helper'

describe V1::AnnouncementsController do
  describe '#show' do
    subject { get :show, params: { id: id } }

    let!(:announcement_1) { create(:announcement) }
    let!(:announcement_2) { create(:announcement) }
    let(:id) { announcement_1.id }

    it 'returns a JSON response' do
      subject
      announcement = Announcement.last
      expect(JSON.parse(response.body)).to eql(
        "data" => {
          "attributes"=>{
            "description"=>announcement_1.description,
            "photo-url"=>Rails.application.routes.url_helpers.rails_blob_url(announcement_1.photo),
            "price-cents"=>announcement_1.price_cents,
            "title"=>announcement_1.title
          },
          "id"=>announcement_1.id.to_s,
          "type"=>"announcements"
        }
      )
    end

    context "unexisting id" do
      before do
        announcement_1.destroy
      end

      it 'returns status 404' do
        subject
        expect(response).to have_http_status 404
      end

      it 'returns a JSON response' do
        subject
        announcement = Announcement.last
        expect(JSON.parse(response.body)).to eql(
           {"error"=>"Couldn't find Announcement with 'id'=#{announcement_1.id}"}
        )
      end
    end
  end
end

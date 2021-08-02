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
        ],
         "links"=>{
            "self"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25",
            "first"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25",
            "prev"=>nil, "next"=>nil,
            "last"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25"
        }
      )
    end

    context "filtering" do
      it "searches by title" do
        get :index, params: { q: { title_cont: "#{announcement_1.title[-1]}"} }

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
              "type"=>"announcements"}
          ],
           "links"=>{
              "self"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Btitle_cont%5D=3",
              "first"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Btitle_cont%5D=3",
              "prev"=>nil, "next"=>nil,
              "last"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Btitle_cont%5D=3"
          }
        )
      end

      it "filters by price_cent value" do
        announcement_2.update(price_cents: announcement_2.price_cents + 2)

        get :index, params: { q: { price_cents_gt: announcement_1.price_cents + 1 } }

        expect(JSON.parse(response.body)).to eql(
          "data" => [
            {
              "attributes"=>{
                "description"=>announcement_2.description,
                "photo-url"=>Rails.application.routes.url_helpers.rails_blob_url(announcement_2.photo),
                "price-cents"=>announcement_2.price_cents,
                "title"=>announcement_2.title
              },
              "id"=>announcement_2.id.to_s,
              "type"=>"announcements"}
          ],
           "links"=>{
              "self"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Bprice_cents_gt%5D=1000001",
              "first"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Bprice_cents_gt%5D=1000001",
              "prev"=>nil, "next"=>nil,
              "last"=>"http://test.host/v1/announcements?page%5Bnumber%5D=1&page%5Bsize%5D=25&q%5Bprice_cents_gt%5D=1000001"
          }
        )
      end
    end
  end
end

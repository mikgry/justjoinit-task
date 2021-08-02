FactoryBot.define do
  factory :announcement do
    sequence(:title) { |n| "Title {n}" }
    description { "Description" }
    price_cents { 1_000_000 }

    after(:build) do |announcement|
      file = Rails.root.join('spec/fixtures/files/photo.jpeg')
      announcement.photo.attach(io: File.open(file), filename: File.basename(file))
    end
  end
end

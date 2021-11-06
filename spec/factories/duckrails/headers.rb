FactoryBot.define do
  factory :header, class: Duckrails::Header do
    name { 'Authorization' }
    value { 'ABCDEF1234567890' }
  end
end

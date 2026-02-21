FactoryBot.define do
  factory :mock, class: Duckrails::Mock do
    status { '200' }
    request_method  { 'get' }
    content_type { 'application/json' }
    sequence(:route_path) { |n| "/mocks/#{n}/:id" }
    sequence(:name) { |n| "Default mock #{n}" }
    active { true }
    sequence(:mock_order)
  end
end

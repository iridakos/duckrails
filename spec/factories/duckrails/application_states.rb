FactoryBot.define do
  factory :application_state, class: Duckrails::ApplicationState do
    mock_synchronization_token { '123456' }
  end
end

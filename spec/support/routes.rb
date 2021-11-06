RSpec.configure do |config|
  config.before(:each) do
    Duckrails::Router.clear_routes!(reload: true)
  end
end

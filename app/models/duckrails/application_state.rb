require 'duckrails/synchronizer'

module Duckrails
  # The application state
  class ApplicationState < ActiveRecord::Base
    self.table_name = 'application_state'

    default_scope { order(id: :desc) }

    validates :singleton_guard, inclusion: { in: [0] }
    validates :mock_synchronization_token, presence: true

    def update_token(type)
      case type
      when :mock
        after_save :save_timestamp
        save
      end
    end

    def save_timestamp
      ts = Time.zone.now.to_i
      Rails.cache.write(:routes_changed_timestamp, ts)
    end
  end
end

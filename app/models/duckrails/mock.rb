module Duckrails
  class Mock < ActiveRecord::Base
    has_many :headers, dependent: :destroy, inverse_of: :mock
    accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: :all_blank

    validates :status, presence: true
    validates :request_method, presence: true
    validates :content_type, presence: true
    validates :route_path, presence: true, route: true
    validates :name, presence: true, uniqueness: { case_sensitive: false }

    validates :body_type, inclusion: {
                            in: Duckrails::Scripts.enabled_script_types,
                            allow_blank: true
                          },
                          presence: {
                            unless: -> { body_content.blank? }
                          }

    validates :body_content, presence: { unless: -> { body_type.blank? } }

    validates :script_type, inclusion: {
                              in: Duckrails::Scripts.enabled_script_types,
                              allow_blank: true
                            },
                            presence: { unless: -> { script.blank? } }

                            validates :script, presence: { unless: -> { script_type.blank? } }
    validates :active, presence: { if: -> { active.nil? } }

    before_save :set_order
    after_save :register
    after_destroy :unregister

    default_scope { order(mock_order: :asc) }

    def dynamic?
      body_type != Duckrails::Scripts::SCRIPT_TYPE_STATIC
    end

    def activate!
      self.update!(active: true)
    end

    def deactivate!
      self.update!(active: false)
    end

    #########
    protected
    #########

    def set_order
      self.mock_order ||= (Duckrails::Mock.maximum(:mock_order) || 0) + 1
    end

    def register
      Duckrails::Router.register_mock self
    end

    def unregister
      Duckrails::Router.unregister_mock self
    end
  end
end

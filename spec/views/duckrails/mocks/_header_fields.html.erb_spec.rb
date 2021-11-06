require 'rails_helper'

RSpec.describe 'duckrails/mocks/_form.html.erb', type: :view do
  let(:mock) { Duckrails::Mock.new(headers: [FactoryBot.build(:header)]) }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    assign :mock, mock

    f = nil
    view.simple_form_for mock do |form|
      form.simple_fields_for :headers do |fields_form|
        f = fields_form
      end
    end

    render partial: 'header_fields', locals: { f: f }
  end

  subject { rendered }

  it { should have_field 'Name' }
  it { should have_css '.form-text.text-muted', text: t(:field_header_name_hint) }

  it { should have_field 'Value' }
  it { should have_css '.form-text.text-muted', text: t(:field_header_value_hint) }

  it { should have_css 'a[href="#"] i.fa.fa-remove' }
end

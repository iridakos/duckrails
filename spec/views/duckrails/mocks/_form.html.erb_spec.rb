require 'rails_helper'

RSpec.describe 'duckrails/mocks/_form.html.erb', type: :view do
  let(:title) { t('Home') }
  let(:mock) { Duckrails::Mock.new }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    assign :mock, mock

    render
  end

  subject { page }

  it { should have_css "form[method='post'][action='#{view.duckrails_mocks_path}']" }

  context 'for new record' do
    it { should_not have_css 'input[type="hidden"][name="_method"][value="patch"]', visible: false }
  end

  context 'for existing record' do
    let(:mock) { FactoryBot.create :mock }

    it { should have_css 'input[type="hidden"][name="_method"][value="patch"]', visible: false }
  end

  context 'tabs' do
    it { should have_css 'ul.nav-tabs .nav-item a.active[href="#general"]', text: t(:general_tab) }
    it { should have_css 'ul.nav-tabs .nav-item a[href="#response-body"]', text: t(:response_body_tab) }
    it { should have_css 'ul.nav-tabs .nav-item a[href="#headers"]', text: t(:headers_tab) }
    it { should have_css 'ul.nav-tabs .nav-item a[href="#advanced"]', text: t(:advanced_tab) }
  end

  context 'tab content' do
    context 'general tab' do
      subject { page.find '.tab-content #general' }

      it { should have_css 'p', text: t(:general_tab_header) }

      it { should have_field 'Name', type: 'text' }
      it { should have_css '.form-text.text-muted', text: t(:field_name_hint) }

      it { should have_field 'Active', type: 'checkbox' }
      it { should have_css '.form-text.text-muted', text: t(:field_active_hint) }

      it { should have_field 'Description', type: 'textarea' }
      it { should have_css '.form-text.text-muted', text: t(:field_description_hint) }

      it { should have_field 'Request method', type: 'select' }
      it { should have_css '.form-text.text-muted', text: t(:field_request_method_hint) }

      it { should have_field 'Status', type: 'number' }
      it { should have_css '.form-text.text-muted', text: t(:field_status_hint) }

      it { should have_field 'Route path', type: 'text' }
      it { should have_css '.form-text.text-muted', text: t(:field_route_path_hint) }
    end

    context 'response body' do
      subject { page.find '.tab-content #response-body' }

      it { should have_css 'p', text: t(:response_body_tab_header) }

      it { should have_field 'Body type', type: 'select' }
      it { should have_css '.form-text.text-muted', text: t(:field_body_type_hint) }

      it { should have_field 'Content type', type: 'select' }
      it { should have_css '.form-text.text-muted', text: t(:field_content_type_hint) }

      it { should have_field 'Body content', type: 'textarea' }
      it { should have_css '.form-text.text-muted', text: t(:field_body_content_hint) }
    end

    context 'headers' do
      subject { page.find '.tab-content #headers' }

      it { should have_css 'p', text: t(:headers_tab_header) }
      it { should have_css "a[title='#{t(:add_header_link_title)}'] span", text: t(:add_header) }

      context 'with headers' do
        let(:mock) { FactoryBot.build(:mock, headers: 3.times.map{ FactoryBot.build :header })}

        it { should render_template partial: '_header_fields', count: 4 }
      end

      context 'without headers' do
        it { should render_template partial: '_header_fields', count: 1 }
      end
    end

    context 'advanced' do
      subject { page.find '.tab-content #advanced' }

      it { should have_css 'p', text: t(:advanced_tab_header) }

      it { should have_field 'Script type', type: 'select' }
      it { should have_css '.form-text.text-muted', text: t(:field_script_type_hint) }

      it { should have_field 'Script', type: 'textarea' }
      it { should have_css '.form-text.text-muted', text: t(:field_script_hint) }
    end
  end

  context 'actions' do
    context 'with existing record' do
      let(:mock) { FactoryBot.create :mock }

      it { should have_css "a[href='#{duckrails_mock_path(mock)}'][data-method='delete'][data-confirm='#{t(:mock_deletion_confirmation)}']", text: t(:delete) }
    end

    context 'with new record' do
      let(:mock) { FactoryBot.build :mock }

      it { should_not have_css 'a', text: t(:delete) }
    end

    it { should have_css "a[href='#{duckrails_mocks_path}']", text: t(:cancel) }
    it { should have_css "input[type='submit'][value='#{t(:save)}']" }
  end
end

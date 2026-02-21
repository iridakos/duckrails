require 'rails_helper'

RSpec.describe 'duckrails/mocks/sort_index.html.erb', type: :view do
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    3.times do
      FactoryBot.create(:mock)
    end

    assign :mocks, Duckrails::Mock.all

    render
  end

  subject { page }

  context 'content' do
    it { should have_css '.sortable', count: 1 }
    it { should have_css ".sortable[data-mock-url='#{update_order_duckrails_mocks_path}']" }
    it { should have_css ".sortable[data-mock-method='put']" }
    it { should have_css ".sortable[data-mock-success-url='#{duckrails_mocks_path}']" }

    context 'mocks' do
      subject { page.find '.sortable' }

      it 'should render all mocks' do
        Duckrails::Mock.all.each do |mock|
          expect(subject).to have_css ".mock[data-mock-id='#{mock.id}'][data-old-pos='#{mock.mock_order}']"
          expect(subject).to have_css '.mock .mock-name', text: mock.name
          expect(subject).to have_css '.mock .mock-path', text: mock.route_path
          expect(subject).to have_css '.mock .mock-request-method', text: mock.request_method
        end
      end
    end

    it { should have_css "a.btn.btn-secondary[href='#{duckrails_mocks_path}']", text: t(:cancel) }
    it { should have_css "a.btn.btn-success.update-mocks-order[href='#']", text: t(:save) }
  end
end

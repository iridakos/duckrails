require 'rails_helper'

module Duckrails
  RSpec.describe Duckrails::MocksController, type: :controller do
    describe 'action callbacks' do
      context '#load_mock' do
        it { should execute_before_action :load_mock, :on => :edit, with: { id: 'foo' } }
        it { should execute_before_action :load_mock, :on => :update, with: { id: 'foo' } }
        it { should execute_before_action :load_mock, :on => :destroy, with: { id: 'foo' } }
        it { should execute_before_action :load_mock, :on => :activate, with: { id: 'foo' } }
        it { should execute_before_action :load_mock, :on => :deactivate, with: { id: 'foo' } }
        it { should_not execute_before_action :load_mock, :on => :index }
        it { should_not execute_before_action :load_mock, :on => :new }
        it { should_not execute_before_action :load_mock, :on => :create }
        it { should_not execute_before_action :load_mock, :on => :update_order }

        describe '#serve_mock' do
          let(:mock) { FactoryBot.build :mock }

          before do
            mock.save!

            Duckrails::Application.routes_reloader.reload!
          end

          it { should_not execute_before_action :load_mock, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
          it { should_not execute_before_action :verify_authenticity_token, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
          it { should_not execute_after_action :reload_routes, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
        end
      end

      context '#reload_routes' do
        let(:mock) { FactoryBot.create(:mock) }

        it { should execute_after_action :reload_routes, :on => :update, with: { id: mock.id } }
        it { should execute_after_action :reload_routes, :on => :create }
        it { should execute_after_action :reload_routes, :on => :destroy, with: { id: mock.id } }
        it { should execute_after_action :reload_routes, :on => :activate, with: { id: mock.id } }
        it { should execute_after_action :reload_routes, :on => :deactivate, with: { id: mock.id } }
        it { should execute_after_action :reload_routes, :on => :update_order }
        it { should_not execute_after_action :reload_routes, :on => :index }
        it { should_not execute_after_action :reload_routes, :on => :new }
      end
    end

    describe "GET #index" do
      let(:page) { nil }
      let(:per) { nil }
      let(:sort) { nil }

      before do
        if sort
          expect(Duckrails::Mock).to receive(:all).at_least(1).times.and_call_original
          expect(Duckrails::Mock).to receive(:page).never
        else
          mock_relation = double('mock_relation').as_null_object
          expect(Duckrails::Mock).to receive(:page).with(page).and_return(mock_relation)
          expect(mock_relation).to receive(:per).with(per)
        end

        get :index, params: { page: page, sort: sort, per: per }.reject { |_, v| v.blank? }
      end

      context 'without sort parameter' do
        context 'with page parameter' do
          let(:page) { '10' }

          describe 'response' do
            subject { response }

            it { should have_http_status :success }
            it { should render_template :index  }
          end
        end

        context 'with per parameter' do
          let(:per) { '10' }

          describe 'response' do
            subject { response }

            it { should have_http_status :success }
            it { should render_template :index  }
          end
        end

        context 'with page and per parameter' do
          let(:per) { '10' }
          let(:page) { '10' }

          describe 'response' do
            subject { response }

            it { should have_http_status :success }
            it { should render_template :index  }
          end
        end

        context 'without page parameter' do
          let(:page) { nil }

          describe 'response' do
            subject { response }

            it { should have_http_status :success }
            it { should render_template :index  }
          end
        end
      end

      context 'with sort parameter' do
        let(:sort) { true }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :sort_index }
        end
      end
    end

    describe 'GET #edit' do
      let(:mock) { FactoryBot.create :mock }

      before do
        get :edit, params: { id: mock.id }
      end

      describe 'response' do
        subject { response }

        it { should have_http_status :success }
        it { should render_template :edit  }
      end

      describe '@mock' do
        subject { assigns :mock }

        it { should eq mock }
      end
    end

    describe 'GET #new' do
      let(:mock) { FactoryBot.build :mock }

      before do
        expect(Mock).to receive(:new).once.and_return(mock)

        get :new
      end

      describe 'response' do
        subject { response }

        it { should have_http_status :success }
        it { should render_template :new  }
      end

      describe '@mock' do
        subject { assigns :mock }

        it { should eq mock }
      end
    end

    describe 'POST #create' do
      let(:mock) { FactoryBot.build :mock }
      let(:valid) { nil }

      before do
        expect(controller).to receive(:mock_params).and_call_original
        expect_any_instance_of(Mock).to receive(:save).once.and_return(valid)

        post :create, params: { id: mock.id, duckrails_mock: FactoryBot.attributes_for(:mock, name: 'Default mock') }
      end

      context 'with valid mock' do
        let(:valid) { true }

        describe 'response' do
          subject { response }

          it { should have_http_status :redirect }
          it { should redirect_to duckrails_mocks_path  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Default mock'
          end
        end
      end

      context 'with invalid mock' do
        let(:valid) { false }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :new  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Default mock'
          end
        end
      end
    end

    describe 'PUT/PATCH #update' do
      let(:mock) { FactoryBot.create :mock }
      let(:valid) { nil }

      before do
        expect(controller).to receive(:mock_params).and_call_original
        expect_any_instance_of(Mock).to receive(:save).once.and_return(valid)

        put :update, params: { id: mock.id, duckrails_mock: { name: 'Updated Name' } }
      end

      context 'with valid mock' do
        let(:valid) { true }

        describe 'response' do
          subject { response }

          it { should have_http_status :redirect }
          it { should redirect_to duckrails_mocks_path  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Updated Name'
          end
        end
      end

      context 'with invalid mock' do
        let(:valid) { false }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :edit  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Updated Name'
          end
        end
      end
    end

    describe 'PUT #update_order' do
      before do
        FactoryBot.rewind_sequences
        3.times do |i|
          FactoryBot.create(:mock, mock_order: nil)
        end
      end

      it 'should update orders' do
        old_order = Duckrails::Mock.pluck(:id)
        expect(old_order).to eq [1, 2, 3]

        put :update_order, params: { order: { 0 => { id: 1, order: 3 }, 1 => { id: 3, order: 1} } }

        new_order = Duckrails::Mock.pluck(:id)
        expect(new_order).not_to eq old_order
        expect(new_order).to eq [3, 2, 1]

        expect(response.body).to be_blank
      end
    end

    describe 'DELETE #destroy' do
      let(:mock) { FactoryBot.create :mock }

      before do
        expect(Duckrails::Router).to receive(:unregister_mock).with(mock).once.and_call_original

        delete :destroy, params: { id: mock.id }
      end

      describe 'response' do
        subject { response }

        it { should redirect_to duckrails_mocks_path }
      end
    end

    describe 'put #activate' do
      let(:mock) { FactoryBot.create :mock, active: false }

      before do
        expect(mock).to receive(:activate!).and_call_original
        allow(Mock).to receive(:find).twice.and_return(mock)

        put :activate, params: { id: mock.id }
      end

      describe 'response' do
        subject { response }

        it { should redirect_to duckrails_mocks_path }
      end
    end

    describe 'put #deactivate' do
      let(:mock) { FactoryBot.create :mock, active: true }

      before do
        expect(mock).to receive(:deactivate!).and_call_original
        allow(Mock).to receive(:find).twice.and_return(mock)

        put :deactivate, params: { id: mock.id }
      end

      describe 'response' do
        subject { response }

        it { should redirect_to duckrails_mocks_path }
      end
    end

    describe '#serve_mock' do
      let(:body_type) { nil }
      let(:body_content) { nil }
      let(:script_type) { nil }
      let(:script) { nil }
      let(:script_body) { nil }
      let(:headers) { nil }
      let(:body_type) { Duckrails::Scripts::SCRIPT_TYPE_STATIC }
      let(:body_content) { 'Hello world' }
      let!(:mock) { FactoryBot.create(:mock,
                                      headers: headers || [],
                                      body_type: body_type,
                                      body_content: body_content,
                                      script_type: script_type,
                                      script: script ) }

      before do
        Duckrails::Application.routes_reloader.reload!

        expect_any_instance_of(Duckrails::Scripts::Handlers::Base).to(
          receive(:evaluate).with(script, anything, force_json: true).once.and_call_original
        ) if script_type

        expect_any_instance_of(Duckrails::Scripts::Handlers::Base).to(
          receive(:evaluate).with(body_content, anything).once.and_call_original
        ) unless script_body
      end

      context 'without script' do
        context 'without headers' do
          it 'should respond with mock\'s body, content & status' do
            expect(controller).to receive(:add_response_header).never

            get :serve_mock, params: { id: mock.id, duckrails_mock_id: mock.id }

            expect(response.body).to eq body_content
            expect(response.content_type).to start_with(mock.content_type)
            expect(response.status).to eq mock.status
          end
        end

        context 'with headers' do
          let(:headers) {
            [ FactoryBot.build(:header, name: 'Header 1', value: 'Value 1'),
              FactoryBot.build(:header, name: 'Header 2', value: 'Value 2')] }

          it 'should respond with mock\'s body, content, status & headers' do
            expect(controller).to receive(:add_response_header).twice.and_call_original

            get :serve_mock, params: { id: mock.id, duckrails_mock_id: mock.id }

            expect(response.body).to eq body_content
            expect(response.content_type).to start_with(mock.content_type)
            expect(response.status).to eq mock.status
            expect(response.headers['Header 1']).to eq 'Value 1'
            expect(response.headers['Header 2']).to eq 'Value 2'
          end
        end
      end

      context 'with script' do
        let(:script_type) { Duckrails::Scripts::SCRIPT_TYPE_EMBEDDED_RUBY }
        let(:script_headers) { [{ name: "Header 1", value: "Override 1" }, { name: "Header 3", value: "New Header" }] }
        let(:content_type) { 'application/duckrails' }
        let(:status_code) { 418 }
        let(:script_body) { '<h1>Overriden body</h1>' }
        let(:script) { "{ \"headers\": #{script_headers.to_json}, \"content_type\": \"#{content_type}\", \"status_code\": #{status_code}, \"body\": \"#{script_body}\" }" }

        context 'without headers' do
          it 'should respond with mock\'s body, override content, status & add new headers' do
            expect(controller).to receive(:add_response_header).exactly(2).times.and_call_original

            get :serve_mock, params: { id: mock.id, duckrails_mock_id: mock.id }

            expect(response.body).to eq script_body
            expect(response.content_type).to start_with content_type
            expect(response.status).to eq status_code
            expect(response.headers['Header 1']).to eq 'Override 1'
            expect(response.headers['Header 3']).to eq 'New Header'
          end
        end

        context 'with headers' do
          let(:headers) {
            [ FactoryBot.build(:header, name: 'Header 1', value: 'Value 1'),
              FactoryBot.build(:header, name: 'Header 2', value: 'Value 2')] }

          it 'should respond with mock\'s body, content, status & headers' do
            expect(controller).to receive(:add_response_header).exactly(4).times.and_call_original

            get :serve_mock, params: { id: mock.id, duckrails_mock_id: mock.id }

            expect(response.body).to eq script_body
            expect(response.content_type).to start_with content_type
            expect(response.status).to eq status_code
            expect(response.headers['Header 1']).to eq 'Override 1'
            expect(response.headers['Header 2']).to eq 'Value 2'
            expect(response.headers['Header 3']).to eq 'New Header'
          end
        end
      end
    end

    describe '#default_url_options' do
      let(:params) { {
                       page: 10,
                       per: 5
                     } }

      before do
        allow(controller).to receive(:params).and_return(params)
      end

      subject { controller.default_url_options }

      it { is_expected.to eq({ :page=>10,
                               :per=>5 }) }
    end

    ###########
    # protected
    ###########

    describe '#add_response_header' do
      let(:response) { ActionDispatch::TestResponse.new }
      let(:header) { FactoryBot.build :header }

      it 'should' do
        expect(controller).to receive(:response).and_return(response)

        controller.send(:add_response_header, header)

        expect(response.headers['Authorization']).to eq header.value
      end
    end

    describe '#reload_routes' do
      it 'should request route reloading' do
        expect(Duckrails::Application.routes_reloader).to receive(:reload!).once

        controller.send(:reload_routes)
      end
    end

    describe '#mock_params' do
      let(:parameters) {
        { duckrails_mock: {
          name: 'Name',
          active: true,
          description: 'Description',
          status: 'Status',
          body_type: 'Body type',
          script_type: 'Script type',
          script: 'Script',
          request_method: 'Request method',
          content_type: 'Content type',
          route_path: 'Route path',
          headers_attributes: {
            '0' => {
              name: 'Header 0 Name',
              value: 'Header 0 Value',
              _destroy: false
            },
            '1' => {
              name: 'Header 1 Name',
              value: 'Header 1 Value',
              _destroy: true
            }
            } } } }

      let(:invalid_parameters) {
        result = parameters.dup
        result[:duckrails_mock][:first_level_forbidden] = 'Forbidden'
        result[:duckrails_mock][:headers_attributes]['0'][:second_level_forbidden] = 'Forbidden'
        result
      }
      let(:params) { ActionController::Parameters.new parameters }
      let(:invalid_params) { ActionController::Parameters.new parameters }


      it 'should allow specific attributes' do
        expect(controller).to receive(:params).and_return(params)

        expect(controller.send(:mock_params)).to eq parameters[:duckrails_mock].with_indifferent_access
      end

      it 'should ignore forbidden attributes' do
        expect(controller).to receive(:params).and_return(invalid_params)

        expect(controller.send(:mock_params)).to eq parameters[:duckrails_mock].with_indifferent_access
      end
    end

    describe '#load_mock' do
      let(:mock) { FactoryBot.build(:mock) }

      it 'should load the mock with the specific params id' do
        expect(controller).to receive(:params).and_return(ActionController::Parameters.new(id: 1))
        expect(Duckrails::Mock).to receive(:find).with(1).once.and_return(mock)

        controller.send(:load_mock)
        expect(controller.instance_variable_get(:@mock)).to eq mock
      end
    end
  end
end

require 'rails_helper'

module Duckrails
  RSpec.describe Mock, type: :model do
    context 'attributes' do
      it { should respond_to :headers, :headers= }
      it { should respond_to :status, :status= }
      it { should respond_to :request_method, :request_method= }
      it { should respond_to :content_type, :content_type= }
      it { should respond_to :route_path, :route_path= }
      it { should respond_to :name, :name= }
      it { should respond_to :body_type, :body_type= }
      it { should respond_to :body_content, :body_content= }
      it { should respond_to :script_type, :script_type= }
      it { should respond_to :script, :script= }
      it { should respond_to :active, :active=, :active? }
    end

    context 'relations' do
      it { should have_many(:headers).dependent(:destroy) }
      it { should accept_nested_attributes_for(:headers).allow_destroy(true) }

      it 'should reject headers if all values are nil' do
        mock = FactoryBot.build(:mock)
        mock.headers_attributes = [{}]
        expect(mock.save).to be true
      end
    end

    context 'validations' do
      context 'presence' do
        it { should validate_presence_of :status }
        it { should validate_presence_of :request_method}
        it { should validate_presence_of :content_type}
        it { should validate_presence_of :route_path}
        it { should validate_presence_of :name }
        it { should validate_presence_of :active }

        context '#body_type' do
          it 'should not validate presence if body content is empty' do
            mock = FactoryBot.build :mock, body_content: nil
            expect(mock).not_to validate_presence_of :body_type
          end

          it 'should validate presence if body content is present' do
            mock = FactoryBot.build :mock, body_content: 'DuckRails'
            expect(mock).to validate_presence_of :body_type
          end
        end

        context '#body_content' do
          it 'should not validate presence if body type is empty' do
            mock = FactoryBot.build :mock, body_type: nil
            expect(mock).not_to validate_presence_of :body_content
          end

          it 'should validate presence if body type is present' do
            mock = FactoryBot.build :mock, body_type: 'embedded_ruby'
            expect(mock).to validate_presence_of :body_content
          end
        end

        context '#script_type' do
          it 'should not validate presence if script content is empty' do
            mock = FactoryBot.build :mock, script: nil
            expect(mock).not_to validate_presence_of :script_type
          end

          it 'should validate presence if script content is present' do
            mock = FactoryBot.build :mock, script: 'DuckRails'
            expect(mock).to validate_presence_of :script_type
          end
        end

        context '#script' do
          it 'should not validate presence if script type is empty' do
            mock = FactoryBot.build :mock, script_type: nil
            expect(mock).not_to validate_presence_of :script
          end

          it 'should validate presence if script type is present' do
            mock = FactoryBot.build :mock, script_type: 'embedded_ruby'
            expect(mock).to validate_presence_of :script
          end
        end
      end

      context 'uniqueness' do
        context '#name' do
          subject { FactoryBot.create :mock, name: 'Default mock' }

          it { should validate_uniqueness_of(:name).case_insensitive }
        end

        context '#route_path' do
          it 'should allow duplicates with same methods' do
            FactoryBot.create(:mock, route_path: '/a_mock')

            mock = FactoryBot.build(:mock, route_path: '/a_mock')
            expect(mock).to be_valid
          end

          it 'should allow duplicates with different methods' do
            FactoryBot.create(:mock, route_path: '/a_mock')

            mock = FactoryBot.build(:mock, request_method: 'post', route_path: '/a_mock')
            expect(mock).to be_valid
            expect(mock.errors[:route_path].size).to eq 0
          end
        end
      end

      context 'inclusion' do
        it { should validate_inclusion_of(:body_type).
          in_array([Duckrails::Scripts::SCRIPT_TYPE_STATIC,
            Duckrails::Scripts::SCRIPT_TYPE_EMBEDDED_RUBY])
        }

        it {
          should validate_inclusion_of(:script_type).
          in_array([Duckrails::Scripts::SCRIPT_TYPE_STATIC,
            Duckrails::Scripts::SCRIPT_TYPE_EMBEDDED_RUBY])
        }
      end

      context 'route' do
        context 'with Bad URI' do
          it 'should be invalid' do
            mock = FactoryBot.build :mock, route_path: 'httpgih[]com'

            expect(mock).to be_invalid
            expect(mock.errors[:route_path]).to include 'is not a valid route'
          end
        end

        context 'with action not served by the mocks controller' do
          it 'should be invalid' do
            mock = FactoryBot.build :mock, route_path: '/'

            expect(mock).to be_invalid
            expect(mock.errors[:route_path]).to include 'already in use'
          end
        end

        context 'with action served by the mocks controller but not by the #serve_mock method' do
          it 'should be invalid' do
            mock = FactoryBot.build :mock, route_path: '/duckrails/mocks'

            expect(mock).to be_invalid
            expect(mock.errors[:route_path]).to include 'already in use'
          end
        end

        context 'with action served by the mocks controller, by the #serve_mock method but for another mock' do
          it 'should be valid' do
            FactoryBot.create :mock, route_path: '/a_mock'
            mock = FactoryBot.build :mock, route_path: '/a_mock'

            expect(mock).to be_valid
          end
        end

        context 'updating an existing mock without changing the route passes' do
          it 'should be valid' do
            mock = FactoryBot.create :mock
            mock.name = 'Changed Default Name'
            expect(mock).to be_valid
          end
        end
      end
    end

    context 'scopes' do
      context 'default scope' do
        before do
          3.times do |i|
            FactoryBot.create :mock, id: i, mock_order: (4 - i)
          end
        end

        it 'should bring the mocks order by the mock_order column' do
          expect(Duckrails::Mock.pluck(:id)).to eq [2, 1, 0]
          expect(Duckrails::Mock.unscoped.pluck(:id)).to eq [0, 1, 2]
        end
      end
    end

    context 'methods' do
      describe '#dynamic?' do
        let(:body_type) { nil }

        subject { FactoryBot.build(:mock, body_type: body_type).dynamic? }

        context 'with static body type' do
          let(:body_type) { Duckrails::Scripts::SCRIPT_TYPE_STATIC }

          it { should be false }
        end

        context 'with embedded ruby body type' do
          let(:body_type) { Duckrails::Scripts::SCRIPT_TYPE_EMBEDDED_RUBY }

          it { should be true }
        end

        context 'with js body type' do
          let(:body_type) { Duckrails::Scripts::SCRIPT_TYPE_JS }

          it { should be true }
        end
      end

      describe '#activate!' do
        let(:mock) { FactoryBot.create(:mock, active: false) }

        it 'should activate a mock' do
          expect(mock.active?).to be false
          mock.activate!
          expect(mock.active?).to be true
          mock.reload
          expect(mock.active).to be true
        end
      end

      describe '#deactivate!' do
        let(:mock) { FactoryBot.create(:mock, active: true) }

        it 'should activate a mock' do
          expect(mock.active?).to be true
          mock.deactivate!
          expect(mock.active?).to be false
          mock.reload
          expect(mock.active).to be false
        end
      end
    end

    context 'callbacks' do
      describe '#before_save' do
        let(:mock) { FactoryBot.build(:mock, mock_order: nil) }

        it 'should set order to 0 if no other mocks exist' do
          mock.save
          expect(mock.mock_order).to eq 1
        end

        it 'should set order to max if other mocks exist' do
          FactoryBot.create :mock, mock_order: 100
          mock.save
          expect(mock.mock_order).to eq 101
        end
      end

      describe '#after_save' do
        let(:mock) { FactoryBot.build(:mock) }

        before do
          expect(Duckrails::Router).to receive(:register_mock).with(mock).once
        end

        it 'registers the mock' do
          expect(mock.save).to be true
        end
      end

      describe '#after_destroy' do
        let(:mock) { FactoryBot.create(:mock) }

        before do
          expect(Duckrails::Router).to receive(:unregister_mock).with(mock).once
        end

        it 'registers the mock' do
          expect(mock.destroy).to eq mock
        end
      end
    end

    context 'CRUD' do
      it 'should save mocks' do
        mock = FactoryBot.build :mock

        expect{ mock.save }.to change(Mock, :count).from(0).to(1)
      end

      it 'should update mocks' do
        mock = FactoryBot.create :mock

        mock.name = 'Another Default mock'
        expect(mock.save).to be true

        mock.reload
        expect(mock.name).to eq 'Another Default mock'
      end

      it 'should destroy mocks' do
        mock = FactoryBot.create :mock

        expect{ mock.destroy }.to change(Mock, :count).from(1).to(0)
      end

      it 'should save headers' do
        mock = FactoryBot.build :mock, headers: [ FactoryBot.build(:header) ]

        expect{ mock.save }.to change(Header, :count).from(0).to(1)

        mock.reload
        expect(mock.headers.size).to eq 1
      end
    end
  end
end

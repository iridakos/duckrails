require 'rails_helper'

module Duckrails
  RSpec.describe ApplicationState, type: :model do
    describe 'attributes' do
      it { should respond_to :mock_synchronization_token, :mock_synchronization_token= }
    end

    describe 'validations' do
      it { should validate_inclusion_of(:singleton_guard).in_array([0]) }
      it { should validate_presence_of :mock_synchronization_token }
    end

    describe '.instance' do
      context 'with existing application state' do
        it 'should return the existing application state' do
          state = ApplicationState.create(singleton_guard: 0, mock_synchronization_token: '123456')

          expect(ApplicationState).to receive(:create).never
          expect(ApplicationState.instance).to eq state
        end
      end

      context 'without existing application state' do
        it 'should return the existing application state' do
          expect(Synchronizer).to receive(:generate_token).and_return('123456')
          expect(ApplicationState).to receive(:create).with(singleton_guard: 0, mock_synchronization_token: '123456').once.and_call_original
          expect(ApplicationState.instance.mock_synchronization_token).to eq '123456'
        end
      end
    end

    describe 'CRUD' do
      let(:application_state) { FactoryBot.create :application_state }

      it 'should save application states' do
        application_state = FactoryBot.build :application_state, mock_synchronization_token: '123456'

        expect{ application_state.save }.to change(ApplicationState, :count).from(0).to(1)
      end

      it 'should update application states' do
        application_state = FactoryBot.create :application_state, mock_synchronization_token: '123456'

        application_state.mock_synchronization_token = '789123'
        expect(application_state.save).to be true

        application_state.reload
        expect(application_state.mock_synchronization_token).to eq '789123'
      end

      it 'should destroy application states' do
        application_state = FactoryBot.create :application_state, mock_synchronization_token: '123456'

        expect{ application_state.destroy }.to change(ApplicationState, :count).from(1).to(0)
      end
    end
  end
end

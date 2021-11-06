require 'rails_helper'

module Duckrails
  RSpec.describe MocksHelper, type: :helper do
    describe '#available_mime_types' do
      subject { helper.send :available_mime_types }

      it 'should return all available mime types' do
        expect(subject).to eq Mime::EXTENSION_LOOKUP.map{ |a| a[1].to_s }.uniq.sort
      end

      it 'should show the mime type' do
        expect(subject).to include 'application/json'
      end
    end

    describe '#available_script_types' do
      subject { helper.send :available_script_types }

      it 'should return all available types and their translations' do
        expect(subject.size).to eq 4

        expect(subject).to include ['Embedded Ruby', 'embedded_ruby']
        expect(subject).to include ['Javascript', 'js']
        expect(subject).to include ['Static', 'static']
        expect(subject).to include ['Liquid', 'liquid']
      end
    end
  end
end

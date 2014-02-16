require 'spec_helper'

describe Skebby::Client do
  subject do
    Skebby::Client.new(
      username:  'john.doe',
      password:  'password',
      test_mode: true
    )
  end

  before { VCR.insert_cassette 'player', record: :new_episodes }
  after { VCR.eject_cassette }

  describe '#get_credit' do
    let(:response) { subject.get_credit }

    it 'returns the remaining credit' do
      expect(response[:credit_left]).to eq(1.61972)
    end

    it 'returns the remaining classic SMS' do
      expect(response[:classic_sms]).to eq(25)
    end

    it 'returns the remaining basic SMS' do
      expect(response[:basic_sms]).to eq(35)
    end
  end

  %w(classic basic classic_report).each do |sms_type|
    meth = "send_sms_#{sms_type}"

    describe "##{meth}" do
      context 'with the needed parameters' do
        let(:response) do
          subject.send(meth, {
            recipients: ['393459187391', '393786104981'],
            text:       'Hello, world!'
          })
        end

        it 'returns the remaining SMS' do
          expect(response[:remaining_sms]).to eq(5)
        end
      end

      context 'without parameters' do
        let(:response) do
          subject.send(meth)
        end

        it 'raises an error' do
          expect { response }.to raise_error
        end
      end
    end
  end

  describe '#send_sms_classic_report' do
    let(:response) do
      subject.send_sms_classic_report(
        recipients: ['393459187391', '393786104981'],
        text:       'Hello, world!'
      )
    end

    it "returns the dispatch ID" do
      expect(response[:dispatch_id]).to eq(1392562134)
    end
  end
end

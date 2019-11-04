require 'rails_helper'

describe HappyHouse::MMS::InboundMessage do
  describe '.from_twilio_payload' do
    subject { described_class.from_twilio_payload(payload) }

    let(:payload) do
      {
        "account_sid"           => "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "api_version"           => "2010-04-01",
        "body"                  => "body",
        "date_created"          => "Thu, 30 Jul 2015 20:12:31 +0000",
        "date_sent"             => "Thu, 30 Jul 2015 20:12:33 +0000",
        "date_updated"          => "Thu, 30 Jul 2015 20:12:33 +0000",
        "direction"             => "outbound-api",
        "error_code"            => nil,
        "error_message"         => nil,
        "from"                  => "+15017122661",
        "messaging_service_sid" => "MGXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "num_media"             => "0",
        "num_segments"          => "1",
        "price"                 => nil,
        "price_unit"            => nil,
        "sid"                   => "MMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "status"                => "sent",
        "subresource_uris"      => {
          "media" => "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Media.json"
        },
        "to"                    => "+15558675310",
        "uri"                   => "/2010-04-01/Accounts/ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Messages/SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.json"
      }
    end

    it { is_expected.to be_an_instance_of(HappyHouse::MMS::InboundMessage) }
    
    it 'has a properly formatted sent_at date' do
      expect(subject.sent_at.to_s).to eq('2015-07-30')
    end
  end
end
class MMSController < ApplicationController
  def process_message
    handler = HappyHouse::MMS::Interface.handler_for(inbound_message)

    handler.perform

    render json: { data: 'Success' }, status: :ok
  rescue HappyHouse::MMS::Errors::BaseError => e
    Rails.logger.error(e)

    render json: { error: e }, status: :internal_server_error
  end

  private

  def inbound_message
    # We currently expect the payload to come from Twilio
    HappyHouse::MMS::InboundMessage.from_twilio_payload(params)
  end
end
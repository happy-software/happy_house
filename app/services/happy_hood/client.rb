# frozen_string_literal: true

module HappyHood
  class Client
    attr_reader :zpid, :property

    def initialize(property)
      @property = property
      @zpid     = property.zpid
    end

    def get_history
      make_request(endpoint: :valuations)
    end

    def get_zpid(data)
      @get_zpid_data = data
      make_request(endpoint: :find_zpid)
    end

    private

    # :reek:DuplicateMethodCall
    def make_request(endpoint:)
      # TODO: There's a lot of duplication in here. If these endpoints grow more, we can start DRYing it up.
      return {} unless api_path

      bearer_token = ENV["HAPPY_HOOD_API_TOKEN"]
      case endpoint
      when :valuations
        Rails.cache.fetch("#{Date.today.strftime("%Y-%m-%d")}-#{zpid}") do
          uri = URI("#{api_path}/house_valuations/#{zpid}")
          req = Net::HTTP::Get.new(uri)
          req["Authorization"] = "Bearer token=\"#{bearer_token}\""

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: Rails.env.production?) do |http|
            http.request(req)
          end
          return {} unless response.code.to_i >= 200 && response.code.to_i < 300

          JSON.parse(response.body)["data"]
        end
      when :find_zpid
        uri = URI("#{api_path}/find_zpid")
        req = Net::HTTP::Post.new(uri.request_uri)
        req["Authorization"] = "Bearer token=\"#{bearer_token}\""
        req.set_form_data(@get_zpid_data)

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: Rails.env.production?) { |http| http.request(req) }
        return {} unless response.code.to_i >= 200 && response.code.to_i < 300

        JSON.parse(response.body)["data"]
      else
        raise StandardError, "Unexpected endpoint: #{endpoint}"
      end
    end

    def api_path
      ENV["PRICE_HISTORY_API"]
    end
  end
end

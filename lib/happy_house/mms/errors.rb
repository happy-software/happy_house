module HappyHouse
  module MMS
    module Errors
      class BaseError < StandardError; end
      class UnhandledNumberError < BaseError; end
      class BadRequestError < BaseError; end
    end
  end
end

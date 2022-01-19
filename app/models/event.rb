# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :property
  has_rich_text :content
end

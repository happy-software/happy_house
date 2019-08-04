class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.newest
    order(:created_at => :desc).first
  end

  def self.oldest
    order(:created_at => :desc).last
  end
end

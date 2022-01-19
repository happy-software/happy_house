# frozen_string_literal: true

json.extract! lease, :id, :start_date, :end_date, :details, :property_document_id, :created_at, :updated_at
json.url lease_url(lease, format: :json)

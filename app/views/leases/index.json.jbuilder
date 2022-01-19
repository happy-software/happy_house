# frozen_string_literal: true

json.array! @leases, partial: "leases/lease", as: :lease

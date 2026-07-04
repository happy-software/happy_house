# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap
# All pins below are served from gems — no CDN or Node dependency.

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Rich text (served by the actiontext gem)
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

# Charts (served by the chartkick gem)
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"

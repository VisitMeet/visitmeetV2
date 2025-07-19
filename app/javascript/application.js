import "@hotwired/turbo-rails"
import "controllers"
import "@rails/ujs"

import "jquery"
window.$ = window.jQuery = jQuery

import "autosuggestion"
import "autocomplete"

Rails.start()

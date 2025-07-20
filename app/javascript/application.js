import "@hotwired/turbo-rails"
import "controllers"
import "@rails/ujs"

import "jquery"
window.$ = window.jQuery = jQuery

import "autosuggestion"
import "autocomplete"
import "custom/messages"
import "message_form_controller"
import "channels/index.js"

Rails.start()

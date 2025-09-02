import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers" // Loads all files in app/javascript/controllers/
import "channels"   // Loads all files in app/javascript/channels/
import "autosuggestion"
import "autocomplete"
import "messages"

Rails.start()

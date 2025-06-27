// app/javascript/application.js

import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

import "controllers"
import "jquery"
import "./custom/autocomplete"
import "./custom/autosuggestion"

// Expose jQuery globally if needed
window.$ = window.jQuery = jQuery

// Stimulus setup
const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
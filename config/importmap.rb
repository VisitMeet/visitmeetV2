pin "application", to: "application.js", preload: true
pin "@hotwired/turbo-rails", to: "https://cdn.jsdelivr.net/npm/@hotwired/turbo-rails@7.3.0/app/assets/javascripts/turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/npm/stimulus@3.2.2/dist/stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "https://ga.jspm.io/npm:@hotwired/stimulus-loading@1.2.2/dist/stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin_all_from "app/javascript/channels", under: "channels", preload: true
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js", preload: true
pin "autosuggestion", to: "autosuggestion.js", preload: true
pin "autocomplete", to: "autocomplete.js", preload: true
pin "messages", to: "custom/messages.js", preload: true



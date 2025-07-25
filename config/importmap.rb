pin "application", to: "application.js", preload: true
pin "@hotwired/turbo-rails", to: "/assets/turbo.min-3c33ba92ac879121a67767bb3b0675260e3cc1fd05c61403e2c63a26bbc1ed9c.js", preload: true
pin "@hotwired/stimulus", to: "/assets/stimulus.min-82ab9b5ab642258a9e0b2c0e6acb984cab3360a464465cd4e9996b636efea9e4.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin_all_from "app/javascript/channels", under: "channels", preload: true
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js", preload: true
pin "autosuggestion", to: "autosuggestion.js", preload: true
pin "autocomplete", to: "autocomplete.js", preload: true
pin "messages", to: "custom/messages.js", preload: true
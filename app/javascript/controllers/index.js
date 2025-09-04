// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import "./gallery_controller"
import "./cover_image_controller"
eagerLoadControllersFrom("controllers", application)


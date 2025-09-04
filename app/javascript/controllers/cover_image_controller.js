import { Controller } from "@hotwired/stimulus"

// Handles drag-and-drop for cover image upload
export default class extends Controller {
  static targets = ["input"]

  dragOver(event) {
    event.preventDefault()
  }

  drop(event) {
    event.preventDefault()
    this.inputTarget.files = event.dataTransfer.files
    this.element.requestSubmit()
  }

  change() {
    this.element.requestSubmit()
  }

  select() {
    this.inputTarget.click()
  }
}

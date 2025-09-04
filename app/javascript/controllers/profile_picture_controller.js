import { Controller } from "@hotwired/stimulus"

// Provides live preview for profile picture uploads
export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const url = URL.createObjectURL(file)
    let preview = this.previewTarget
    if (preview.tagName === "IMG") {
      preview.src = url
    } else {
      const img = document.createElement("img")
      img.src = url
      img.alt = this.inputTarget.getAttribute("aria-label") || "Profile picture preview"
      img.className = "w-32 h-32 rounded-full object-cover border-4 border-white dark:border-gray-800"
      img.setAttribute("data-profile-picture-target", "preview")
      preview.replaceWith(img)
    }
  }
}

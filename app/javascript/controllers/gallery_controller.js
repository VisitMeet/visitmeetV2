import { Controller } from "@hotwired/stimulus"

// Manages gallery previews and AJAX photo removal
export default class extends Controller {
  static targets = ["input", "previews", "gallery"]

  connect() {
    this.dataTransfer = new DataTransfer()
  }

  preview(event) {
    const files = Array.from(event.target.files)
    files.forEach(file => {
      this.dataTransfer.items.add(file)
      const wrapper = document.createElement("div")
      wrapper.classList.add("relative", "w-24", "h-24")

      const img = document.createElement("img")
      img.src = URL.createObjectURL(file)
      img.classList.add("object-cover", "w-full", "h-full", "rounded")

      const button = document.createElement("button")
      button.type = "button"
      button.textContent = "✕"
      button.classList.add("absolute", "top-1", "right-1", "bg-red-600", "text-white", "text-xs", "rounded", "px-1")
      button.addEventListener("click", () => {
        for (let i = 0; i < this.dataTransfer.items.length; i++) {
          if (this.dataTransfer.items[i].getAsFile().name === file.name) {
            this.dataTransfer.items.remove(i)
            break
          }
        }
        wrapper.remove()
        this.inputTarget.files = this.dataTransfer.files
      })

      wrapper.appendChild(img)
      wrapper.appendChild(button)
      this.previewsTarget.appendChild(wrapper)
    })

    this.inputTarget.files = this.dataTransfer.files
    event.target.value = null
  }

  removeExisting(event) {
    const url = event.currentTarget.dataset.url
    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch(url, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": token,
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        this.galleryTarget.innerHTML = data.html
      })
  }
}

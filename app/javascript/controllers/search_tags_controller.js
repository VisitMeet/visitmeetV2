import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "tags"]

  connect() {
    const existing = this.hiddenTarget?.value || ""
    this.tags = existing.split(',').filter(t => t.length > 0)
    this.renderTags()
  }

  addTag(event) {
    if (event.key === "Enter" && this.inputTarget.value.trim() !== "") {
      event.preventDefault()
      const tag = this.inputTarget.value.trim()
      if (!this.tags.includes(tag)) {
        this.tags.push(tag)
        this.hiddenTarget.value = this.tags.join(",")
        this.renderTags()
        this.element.requestSubmit()
      }
      this.inputTarget.value = ""
    }
  }

  removeTag(event) {
    const tag = event.currentTarget.dataset.tag
    this.tags = this.tags.filter(t => t !== tag)
    this.hiddenTarget.value = this.tags.join(",")
    this.renderTags()
    this.element.requestSubmit()
  }

  renderTags() {
    this.tagsTarget.innerHTML = ""
    this.tags.forEach(tag => {
      const span = document.createElement("span")
      span.className = "bg-blue-100 text-blue-800 text-sm px-2 py-1 rounded-full mr-2 mb-2 inline-flex items-center"
      span.innerHTML = `${tag} <button type="button" data-action="search-tags#removeTag" data-tag="${tag}" class="ml-1">&times;</button>`
      this.tagsTarget.appendChild(span)
    })
  }
}

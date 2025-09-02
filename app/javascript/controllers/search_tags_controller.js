import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "tags", "suggestions"]

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
      this.suggestionsTarget.innerHTML = ""
    }
  }

  fetchSuggestions() {
    const query = this.inputTarget.value.trim()
    if (query.length < 2) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    fetch(`/search_suggestions?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.suggestionsTarget.innerHTML = ""
        data.forEach(suggestion => {
          const li = document.createElement("li")
          li.textContent = suggestion
          li.className = "px-2 py-1 cursor-pointer hover:bg-gray-100"
          li.addEventListener("click", () => this.addSuggestion(suggestion))
          this.suggestionsTarget.appendChild(li)
        })
      })
  }

  addSuggestion(tag) {
    if (!this.tags.includes(tag)) {
      this.tags.push(tag)
      this.hiddenTarget.value = this.tags.join(",")
      this.renderTags()
      this.element.requestSubmit()
    }
    this.inputTarget.value = ""
    this.suggestionsTarget.innerHTML = ""
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

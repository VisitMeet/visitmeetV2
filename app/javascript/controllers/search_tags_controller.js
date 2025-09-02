import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "tags", "suggestions", "loader"]

  connect() {
    const existing = this.hiddenTarget?.value || ""
    this.tags = existing.split(',').filter(t => t.length > 0)
    this.suggestionsTarget.setAttribute("role", "listbox")
    this.inputTarget.addEventListener("blur", () => {
      setTimeout(() => this.clearSuggestions(), 100)
    })
    this.debounceTimeout = null
    this.renderTags()
    this.element.addEventListener("turbo:submit-start", () => this.showLoader())
    this.element.addEventListener("turbo:submit-end", () => this.hideLoader())
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
      this.clearSuggestions()
    }
  }

  fetchSuggestions() {
    clearTimeout(this.debounceTimeout)
    this.debounceTimeout = setTimeout(() => {
      const query = this.inputTarget.value.trim()
      if (query.length < 2) {
        this.clearSuggestions()
        return
      }

      fetch(`/search_suggestions?q=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(data => {
          this.clearSuggestions()

          const renderGroup = (items, label) => {
            if (!items || items.length === 0) return
            const header = document.createElement("li")
            header.textContent = label
            header.className = "px-2 py-1 text-gray-500 font-semibold"
            this.suggestionsTarget.appendChild(header)

            items.forEach(suggestion => {
              const li = document.createElement("li")
              li.textContent = suggestion
              li.className = "px-2 py-1 cursor-pointer hover:bg-gray-100"
              li.setAttribute("role", "option")
              li.addEventListener("click", () => this.addSuggestion(suggestion))
              this.suggestionsTarget.appendChild(li)
            })
          }

          renderGroup(data.tags, "Tags")
          renderGroup(data.locations, "Locations")
        })
        .catch(() => {
          this.clearSuggestions()
          const li = document.createElement("li")
          li.textContent = "Error fetching suggestions"
          li.className = "px-2 py-1 text-red-500"
          li.setAttribute("role", "option")
          this.suggestionsTarget.appendChild(li)
        })
    }, 300)
  }

  addSuggestion(tag) {
    if (!this.tags.includes(tag)) {
      this.tags.push(tag)
      this.hiddenTarget.value = this.tags.join(",")
      this.renderTags()
      this.element.requestSubmit()
    }
    this.inputTarget.value = ""
    this.clearSuggestions()
  }

  removeTag(event) {
    const tag = event.currentTarget.dataset.tag
    this.tags = this.tags.filter(t => t !== tag)
    this.hiddenTarget.value = this.tags.join(",")
    this.renderTags()
    this.element.requestSubmit()
  }

  tagsTargetConnected() {
    // Re-render selected tags when the tag container is replaced (e.g., Turbo frame updates)
    this.renderTags()
  }

  renderTags() {
    this.tagsTarget.innerHTML = ""
    this.tags.forEach(tag => {
      const span = document.createElement("span")
      span.className = "bg-blue-100 text-blue-800 text-sm px-2 py-1 rounded-full mr-2 mb-2 inline-flex items-center"
      const text = document.createTextNode(`${tag} `)
      const button = document.createElement("button")
      button.type = "button"
      button.dataset.action = "search-tags#removeTag"
      button.dataset.tag = tag
      button.className = "ml-1"
      button.textContent = "×"
      span.appendChild(text)
      span.appendChild(button)
      this.tagsTarget.appendChild(span)
    })
  }

  clearSuggestions() {
    this.suggestionsTarget.innerHTML = ""
  }

  showLoader() {
    this.loaderTarget.classList.remove("hidden")
  }

  hideLoader() {
    this.loaderTarget.classList.add("hidden")
  }
}

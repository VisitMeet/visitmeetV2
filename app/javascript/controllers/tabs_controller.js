import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "section"]

  connect() {
    if (this.hasTabTarget) {
      this.show(this.tabTargets[0])
    }
    this.sectionTargets.forEach(section => {
      section.addEventListener("touchstart", e => this.startX = e.touches[0].clientX)
      section.addEventListener("touchend", e => {
        const diff = e.changedTouches[0].clientX - this.startX
        if (Math.abs(diff) > 50) {
          const idx = this.tabTargets.indexOf(this.activeTab)
          const next = diff < 0 ? idx + 1 : idx - 1
          if (this.tabTargets[next]) {
            this.show(this.tabTargets[next])
          }
        }
      })
    })
  }

  select(event) {
    event.preventDefault()
    this.show(event.currentTarget)
  }

  show(tab) {
    this.activeTab = tab
    const name = tab.dataset.tab
    this.tabTargets.forEach(t => {
      const active = t === tab
      t.classList.toggle("border-blue-600", active)
      t.classList.toggle("text-blue-600", active)
      t.classList.toggle("border-transparent", !active)
      t.classList.toggle("text-gray-500", !active)
    })
    this.sectionTargets.forEach(section => {
      section.classList.toggle("hidden", section.dataset.tab !== name)
    })
  }
}

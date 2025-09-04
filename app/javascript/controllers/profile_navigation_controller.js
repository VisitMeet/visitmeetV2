import { Controller } from "@hotwired/stimulus"

// Handles smooth scrolling and active link highlighting for profile sections
export default class extends Controller {
  static targets = ["link", "section"]

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll)
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  scroll(event) {
    event.preventDefault()
    const id = event.currentTarget.getAttribute("href").replace("#", "")
    const section = document.getElementById(id)
    section && section.scrollIntoView({ behavior: "smooth" })
  }

  handleScroll() {
    let current = null
    this.sectionTargets.forEach(section => {
      const rect = section.getBoundingClientRect()
      if (rect.top <= 80 && rect.bottom >= 80) {
        current = section.id
      }
    })

    this.linkTargets.forEach(link => {
      const id = link.getAttribute("href").replace("#", "")
      if (id === current) {
        link.classList.add("bg-blue-600", "text-white")
        link.classList.remove("text-gray-700", "dark:text-gray-200")
      } else {
        link.classList.remove("bg-blue-600", "text-white")
        link.classList.add("text-gray-700", "dark:text-gray-200")
      }
    })
  }
}


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "submitButton"]

  connect() {
    this.resize()
    this.timeout = null
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submitForm()
    }
  }

  submitForm() {
    this.submitButtonTarget.click()
  }

  resize() {
    this.textareaTarget.style.height = "auto"
    this.textareaTarget.style.height = this.textareaTarget.scrollHeight + "px"
  }

  typing() {
    this.channel.perform("typing", { typing_user_id: this.data.get("currentUserId") })
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.channel.perform("stopped_typing", { typing_user_id: null })
    }, 3000)
  }

  stoppedTyping() {
    clearTimeout(this.timeout)
    this.channel.perform("stopped_typing", { typing_user_id: null })
  }

  get channel() {
    return this.application.consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: this.data.get("conversationId") },
      {
        connected() {},
        disconnected() {},
        received(data) {},
        typing(data) { this.perform("typing", data) },
        stopped_typing(data) { this.perform("stopped_typing", data) }
      }
    )
  }
}
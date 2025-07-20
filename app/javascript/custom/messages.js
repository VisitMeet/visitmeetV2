document.addEventListener("turbo:load", () => {
  const messagesContainer = document.getElementById("messages");
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;

    const observer = new MutationObserver(() => {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    });

    observer.observe(messagesContainer, { childList: true });
  }
});
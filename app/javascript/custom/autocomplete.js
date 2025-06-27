class Autocomplete {
  constructor(selector, options) {
    this.input = document.querySelector(selector);
    this.options = options;
    this.suggestionsContainer = document.createElement('div');
    this.suggestionsContainer.classList.add('autocomplete-suggestions');
    this.input.parentNode.appendChild(this.suggestionsContainer);
    this.init();
  }

  init() {
    this.input.addEventListener('input', this.onInput.bind(this));
    this.suggestionsContainer.addEventListener('click', this.onSuggestionClick.bind(this));
  }

  onInput(event) {
    const value = event.target.value;
    if (value.length > 2) {
      this.fetchSuggestions(value);
    } else {
      this.suggestionsContainer.innerHTML = '';
    }
  }

  fetchSuggestions(query) {
    fetch(`/tags?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => this.showSuggestions(data))
      .catch(error => console.error('Error fetching suggestions:', error));
  }

  showSuggestions(suggestions) {
    this.suggestionsContainer.innerHTML = '';
    suggestions.forEach(suggestion => {
      const suggestionElement = document.createElement('div');
      suggestionElement.classList.add('autocomplete-suggestion');
      suggestionElement.textContent = suggestion;
      this.suggestionsContainer.appendChild(suggestionElement);
    });
  }

  onSuggestionClick(event) {
    if (event.target.classList.contains('autocomplete-suggestion')) {
      this.input.value = event.target.textContent;
      this.suggestionsContainer.innerHTML = '';
    }
  }
}

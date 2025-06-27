document.addEventListener('DOMContentLoaded', function() {
  const inputField = document.querySelector('#your-input-field-id');
  const autosuggestionContainer = document.querySelector('#autosuggestion-container');

  if (inputField && autosuggestionContainer) {
    inputField.addEventListener('input', function() {
      // Logic to fetch and display suggestions
      // For example:
      // fetchSuggestions(inputField.value).then(suggestions => {
      //   displaySuggestions(suggestions);
      // });

      // Position the autosuggestion container below the input field
      const rect = inputField.getBoundingClientRect();
      autosuggestionContainer.style.position = 'absolute';
      autosuggestionContainer.style.top = `${rect.bottom + window.scrollY}px`;
      autosuggestionContainer.style.left = `${rect.left + window.scrollX}px`;
      autosuggestionContainer.style.width = `${rect.width}px`;
      autosuggestionContainer.classList.add('bg-white', 'shadow-lg', 'rounded-md', 'mt-1', 'z-10');
    });
  }
});

function displaySuggestions(suggestions) {
  const autosuggestionContainer = document.querySelector('#autosuggestion-container');
  autosuggestionContainer.innerHTML = suggestions.map(suggestion => `
    <div class="p-2 hover:bg-gray-200 cursor-pointer">${suggestion}</div>
  `).join('');
}

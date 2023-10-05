import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mutation-observer"
export default class extends Controller {
  connect() {
    const chatMessages = this.element;
    chatMessages.scrollTop = chatMessages.scrollHeight;
    
    const targetNode = document.getElementById("target");
    
    // Options for the observer (which mutations to observe)
    const config = { attributes: true, childList: true, subtree: true };

    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === "childList") {
          chatMessages.scrollTop = chatMessages.scrollHeight;
        } else if (mutation.type === "attributes") {
          console.log(`The ${mutation.attributeName} attribute was modified.`);
        }
      }
    };

    const observer = new MutationObserver(callback);

    // Start observing the target node for configured mutations
    observer.observe(targetNode, config);
  }

  disconnect() {
    this.observer.disconnect();
  }
}

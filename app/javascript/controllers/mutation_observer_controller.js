import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mutation-observer"
export default class extends Controller {
  connect() {
    const flashMessages = document.querySelectorAll('.alert');

    if(document.querySelector('.alert')) {
      if(document.querySelector('.alert').getAttributeNames().filter((attribute)=> attribute == 'signal' ).length == 0) {
        flashMessages.forEach((message) => {
          setTimeout(() => message.remove(), 2000);
        })
      }
    }

    const chatMessages = this.element;
    chatMessages.scrollTop = chatMessages.scrollHeight;
    
    // const targetNode = document.getElementById("target");
    const targetNode = this.element;
    
    // Options for the observer (which mutations to observe)
    const config = { attributes: true, childList: true, subtree: true };

    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === "childList") {
          const mutationTarget = document.querySelector("[signal=decline-ping]") || document.querySelector("[signal=accept-ping]") 
          if(mutationTarget == null){
            chatMessages.scrollTop = chatMessages.scrollHeight;
          }else{
            setTimeout(()=> mutationTarget.remove(), 2000);
          }
        } else if (mutation.type === "attributes") {
          // console.log(`The ${mutation.attributeName} attribute was modified.`);
        }
      }
    };

    const observer = new MutationObserver(callback);

    // Start observing the target node for configured mutations
    observer.observe(targetNode, config);
  }

  disconnect() {
    if(this.observer) {
      this.observer.disconnect();
    }
  }
}

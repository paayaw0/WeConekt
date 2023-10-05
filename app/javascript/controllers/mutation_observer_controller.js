import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mutation-observer"
export default class extends Controller {
  connect() {
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
            console.log(mutationTarget);
            setTimeout(()=> mutationTarget.remove(), 2000);
          }
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

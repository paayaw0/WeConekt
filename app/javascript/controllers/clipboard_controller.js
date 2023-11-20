import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  connect() {
  }

  copy() {
    let textTocopy = this.element.parentElement.parentElement.querySelector('.m-b-none').innerText;
   
    navigator.clipboard.writeText(textTocopy);
  }
}

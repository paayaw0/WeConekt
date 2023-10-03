import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  removeElement(e) {
    e.preventDefault();
    const form = this.element.parentElement;
    const formData = new FormData(form);
  
    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
      },
    }).then((response) => {
      if (response.ok) {
       
        this.element.parentElement.parentElement.remove();
      } else {
        console.error("Form submission error:", response.statusText);
      }
    });
  }
}

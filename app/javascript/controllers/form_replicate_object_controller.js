import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = [ "template", "destination" ]

  replicate(event) {
    const object = this.templateTarget.cloneNode(true);
    object.value = event.target.dataset['value']
    this.destinationTarget.append(object)
    event.target.closest("form").requestSubmit()
  }
}

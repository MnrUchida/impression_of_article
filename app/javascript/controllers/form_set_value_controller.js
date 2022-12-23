import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = [ "output" ]

  setValue(event) {
    this.outputTarget.value = event.target.dataset['value']
  }
}

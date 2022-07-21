import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "numericality"]

  connect() {
  }

  clearInvalidValues(event) {
    if(event.target.value.length == 0) {
      const value = event.target.value = event.target.value;
    }
  }
}

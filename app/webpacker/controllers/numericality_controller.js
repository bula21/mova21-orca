import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "numericality"]

  connect() {
  }

  clearInvalidValues(event) {
    if(event.target.value.length == 0) {
      alert('Keine gültige Zahl / Pas de chiffre valable / Numero non valido')
      const value = event.target.value = event.target.value;
    }
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "filterable" ]

  connect() {}

  filter(event) {
    let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase()

    this.filterableTargets.forEach((el, i) => {
      let filterableKey = el.innerText.toLowerCase();
      el.classList.toggle("d-none", !filterableKey.includes(lowerCaseFilterTerm))
    })
  }
}

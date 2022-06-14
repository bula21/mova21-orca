import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "filterable"]

  connect() {
  }

  filter(event) {
    let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase()
    this.filterableTargets.forEach((el, i) => {
      let filterableKey = el.innerText.toLowerCase();
      const isNumberRegex = /^\d+$/gm;
      const showCondition = isNumberRegex.exec(lowerCaseFilterTerm) ?
        lowerCaseFilterTerm === el.dataset.unitId : filterableKey.includes(lowerCaseFilterTerm)
      el.classList.toggle("d-none", !showCondition)
    })
  }
}

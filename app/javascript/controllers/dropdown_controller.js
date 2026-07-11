import { Controller } from "@hotwired/stimulus"

// Replaces Bootstrap 4's jQuery dropdown for the navbar account menu.
export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("show")
  }

  // Bound to click@window so an outside click closes the menu.
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }
}

import { Controller } from "@hotwired/stimulus"

// Replaces Bootstrap 4's jQuery collapse for the mobile navbar toggler.
export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle("show")
  }
}

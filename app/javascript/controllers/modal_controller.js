import { Controller } from "@hotwired/stimulus"

// Replaces Bootstrap 4's jQuery modal for the signed-lease upload dialog.
export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.classList.add("show")
    this.dialogTarget.style.display = "block"
    document.body.classList.add("modal-open")
  }

  close() {
    this.dialogTarget.classList.remove("show")
    this.dialogTarget.style.display = "none"
    document.body.classList.remove("modal-open")
  }
}

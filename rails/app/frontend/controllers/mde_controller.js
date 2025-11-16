import { Controller } from "@hotwired/stimulus";
import EasyMDE from 'easymde';

export default class extends Controller {

  connect () {
    console.log("booting mde")
    this.editor = new EasyMDE({ element: this.element, forceSync: true })
  }

  disconnect () {
    this.editor.toTextArea();
    this.editor  = null;
  }
}

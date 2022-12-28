import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "key", "output" ]

  connect() {
    const json_data = this.getStorage()

    this.outputTargets.forEach((element) => {
      const element_data = json_data[element.dataset['outputKey']]
      if (element_data !== null && element_data !== undefined) { element.value = element_data }
      const ev = new Event("input", {
        bubbles: false,
        cancelable: true
      })
      element.dispatchEvent(ev)
    })
  }

  clear_with_confirm() {
    if(confirm('入力情報を初期化します。よろしいですか？')) {
      this.clear()
      this.outputTargets.forEach((element) => {
        const value = element.dataset['defaultValue']
        if (value !== null && value !== undefined) {
          element.value = element.dataset['defaultValue']
        } else {
          element.value = ""
        }
        const ev = new Event("input", {
          bubbles: false,
          cancelable: true
        })
        element.dispatchEvent(ev)
      })
    }
  }

  clear() {
    localStorage.removeItem(this.keyTarget.dataset['recordId'])
  }

  //  入力された情報をStorageに設定
  setStorage(event) {
    const json_data = this.getStorage()
    const element = event.target

    json_data[element.dataset['outputKey']] = element.value
    localStorage.setItem(this.keyTarget.dataset['recordId'], JSON.stringify(json_data))
  }

  getStorage() {
    const storage_data = localStorage.getItem(this.keyTarget.dataset['recordId'])
    let json_data = {}
    if (storage_data !== null) {
      json_data = JSON.parse(storage_data)
    }
    return json_data
  }
}

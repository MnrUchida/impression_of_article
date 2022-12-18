import { Controller } from "@hotwired/stimulus"

// コントローラークラスを定義する
export default class extends Controller {
  // ターゲット（操作対象のDOM）のプロパティを作成
  static targets = [ "content", "output" ]

  connect() {
    this.outputTarget.innerText = this.contentTarget.value.length
  }

  // アクション（イベントに紐づく処理）を定義する
  count() {
    this.outputTarget.innerText = this.contentTarget.value.length
  }
}
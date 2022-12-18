import { Controller } from "@hotwired/stimulus"

// コントローラークラスを定義する
export default class extends Controller {
  // アクション（イベントに紐づく処理）を定義する
  copy(event) {
    // xxxxTargetでターゲットとなるDOMにアクセスできる
    // ターゲット（今回であれば<input>）のvalueをログ吐き
    navigator.clipboard.writeText(event.target.getAttribute('data-content'))
        .then(() => {
          console.log("Text copied to clipboard...")
        })
        .catch(err => {
          console.log('Something went wrong', err);
        })
  }
}
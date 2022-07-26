// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// default
// --- start---
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import '../stylesheets/application'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// ---end---
import 'jquery'
import 'jscroll'
import 'bootstrap'
import '@fortawesome/fontawesome-free'

$(function() {
    $('.jscroll').jscroll({
      loadingHtml: '読み込み中・・・', //記事読み込み中の表示
      autoTrigger: true, // 自動で読み込むか否か、trueで自動、falseでボタンクリックとなる。
      nextSelector: 'a.jscroll-next',  // 次ページリンクのセレクタ
      padding: 20, // 指定したコンテンツの下かた何pxで読み込むかを指定(autoTrigger: trueの場合のみ)
      contentSelector: '.jscroll' // 読み込む範囲の指定
    });
});

import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct HotMain {
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    Column() {
      Web({
        src: 'https://m.jd.com',
        controller: this.controller,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('red')
  }
}
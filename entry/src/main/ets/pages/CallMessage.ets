import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct CallMessage {
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    Column({ space: 10 }) {
      Text('原生页面').fontColor(Color.White)
      Web({
        src: $rawfile('h5/album.html'),
        controller: this.controller
      })
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(Color.Gray)
  }
}
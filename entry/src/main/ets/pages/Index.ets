import { promptAction } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct Index {
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    Column({ space: 10 }) {
      Button('鸿蒙按钮')
        .onClick(() => {
          promptAction.showToast({ message: '点击了鸿蒙按钮' })
        })
      Web({
        // src: 'https://m.jd.com',
        src: $rawfile('h5/index.html'),
        controller: this.controller,
      })
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(Color.Pink)
  }
}
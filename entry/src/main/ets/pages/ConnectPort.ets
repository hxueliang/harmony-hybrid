import { promptAction } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'

const TRANSMIT_PORT_KEY = 'transmit_port_key'

@Entry
@Component
struct ConnectPort {
  controller: webview.WebviewController = new webview.WebviewController()
  currentPorts: webview.WebMessagePort[] = []

  build() {
    Column({ space: 10 }) {
      Button('鸿蒙按钮')
        .onClick(() => {
          promptAction.showToast({ message: '点击了鸿蒙按钮' })
        })
      Web({
        src: $rawfile('h5/index.html'),
        controller: this.controller,
      })
        .width('100%')
        .layoutWeight(1)
        .onPageEnd(() => {
          this.currentPorts = this.controller.createWebMessagePorts()
          if (!this.currentPorts) {
            return
          }
          this.controller.postMessage(TRANSMIT_PORT_KEY, [this.currentPorts[1]], '*')
        })
        .onAlert((event) => {
          promptAction.showToast({ message: event?.message })
          return true
        })
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(Color.Pink)
  }
}
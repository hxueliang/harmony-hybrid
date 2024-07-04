import { promptAction } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'

const TRANSMIT_PORT_KEY = 'transmit_port_key'

@Entry
@Component
struct ConnectPort {
  controller: webview.WebviewController = new webview.WebviewController()
  currentPorts: webview.WebMessagePort[] = []
  @State
  currentH5Time: number = 0

  /** 发送消息给h5 */
  sendMessageToH5() {
    // [native -> h5] 端口发送消息给h5
    this.currentPorts[0].postMessageEvent(JSON.stringify({ type: 'native-time', data: Date.now() }))
  }

  build() {
    Column({ space: 10 }) {
      Button('发送消息给h5')
        .onClick(() => {
          this.sendMessageToH5()
        })
      Text(this.currentH5Time.toString())
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
          // controller发送端口给h5
          this.controller.postMessage(TRANSMIT_PORT_KEY, [this.currentPorts[1]], '*')
          // [h5 -> native] 端口监听h5的消息
          this.currentPorts[0].onMessageEvent((result: webview.WebMessage) => {
            if (typeof result === 'string') {
              const res: H5PostMessageModel = JSON.parse(result)
              if (res.type === 'h5-time') {
                this.currentH5Time = res.data
              }
            }
          })
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

class H5PostMessageModel {
  type: string = ''
  data: number = 0
}
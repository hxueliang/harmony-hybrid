import { webview } from '@kit.ArkWeb'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct HotMain {
  controller: webview.WebviewController = new webview.WebviewController()

  aboutToAppear(): void {
    // 当前页面关闭全屏
    window.getLastWindow(getContext()).then(win => {
      win.setWindowLayoutFullScreen(false)
    })
  }

  build() {
    Column() {
      Web({
        src: 'file://' + getContext().filesDir + '/toutiao/index.html',
        controller: this.controller,
      })
        .domStorageAccess(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('red')
  }
}
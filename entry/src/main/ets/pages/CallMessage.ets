import { webview } from '@kit.ArkWeb'
import { picker } from '@kit.CoreFileKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct CallMessage {
  webSdk: WebSdk = new WebSdk()

  build() {
    Column({ space: 10 }) {
      Text('原生页面').fontColor(Color.White)
      Web({
        src: $rawfile('h5/album.html'),
        controller: this.webSdk.controller
      })
        .width('100%')
        .layoutWeight(1)
        .onAlert((event) => {
          promptAction.showToast({ message: event?.message })
          return true
        })
        .javaScriptProxy({
          name: 'vx',
          methodList: ['openAlbum'],
          controller: this.webSdk.controller,
          object: this.webSdk,
        })
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(Color.Gray)
  }
}

class WebSdk {
  controller: webview.WebviewController = new webview.WebviewController()

  /** 打开相册 */
  async openAlbum(methodName: string) {
    const album = new picker.PhotoViewPicker()
    const image = await album.select({
      maxSelectNumber: 1,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (!image.photoUris.length) {
      return
    }
    // AlertDialog.show({ message: image.photoUris[0] })
    // 调用h5的传过来的methodName方法，并回传入image.photoUris[0]给h5
    this.controller.runJavaScript(`${methodName}('${image.photoUris[0]}')`)
  }
}
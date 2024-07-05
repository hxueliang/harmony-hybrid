import { fileIo } from '@kit.CoreFileKit'
import { request, zlib } from '@kit.BasicServicesKit'
import { promptAction, router, window } from '@kit.ArkUI'
import { OPEN_SUB_WINDOW_KEY } from '../constants'

@Entry
@Component
struct HotStart {
  @State
  currentValue: number = 0
  @State
  totalValue: number = 100

  aboutToAppear(): void {
    this.download()
  }

  aboutToDisappear(): void {
    this.closeWin()
  }

  closeWin() {
    const win = window.findWindow(OPEN_SUB_WINDOW_KEY) // 找到子窗口
    win.destroyWindow() // 销毁窗口
  }

  async download() {
    const fileName = 'toutiao.zip'
    const filesDir = getContext().filesDir
    const filePath = filesDir + '/' + fileName
    const hasFile = fileIo.listFileSync(filesDir).includes(fileName)

    if (hasFile) {
      fileIo.renameSync(filePath, filesDir + '/toutiao.bak.zip')
    }
    const task = await request.downloadFile(getContext(), {
      url: 'https://gitee.com/shuiruohanyu/toutiao_net/raw/master/resources/toutiao.zip',
      filePath
    })
    task.on('progress', (receivedSize, totalSize) => {
      this.currentValue = receivedSize
      this.totalValue = totalSize
    })
    task.on('fail', (err) => {
      console.log(err.toString(), 'x_log')
      promptAction.showToast({
        message: err.toString()
      })
    })
    task.on('complete', () => {
      promptAction.showToast({ message: '加载完成，2秒后跳转' })
      this.decompressFile(filePath)
    })
  }

  async decompressFile(filePath: string) {
    try {
      await zlib.decompressFile(filePath, getContext().filesDir)
      setTimeout(() => {
        this.closeWin()
      }, 2100)
    } catch (err) {
      console.log(err.message, 'x_log')
    }
  }

  build() {
    Row() {
      Column() {
        Text(`已加载...${this.currentValue}`)
        Text(`总大小...${this.totalValue}`)
        Text(`加载中...${(this.currentValue / this.totalValue * 100).toFixed(1)}%`)
      }
      .width('100%')
    }
    .height('100%')
  }
}
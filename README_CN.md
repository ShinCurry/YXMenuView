# YXMenuView

筛选菜单视图

![YXMenuViewDemo](http://windisco.qiniudn.com/YXMenuViewDemo.gif)

### 版本 1.2

## 编译环境
* Swift 2.1
* Xcode 6 或者更高
* Apple LLVM compiler
* iOS 8.0 或者更高
* ARC

## 示例

打开 YXMenuViewDemo 项目并运行

## 安装

### CocoaPods

目前暂时不支持

### 手动安装

1. 把整个 YXMenuVIew 文件夹拖入你的项目文件夹并添加文件到工程目录
2. 把 Framework 添加到 `Embedded Binaries` 和 `Linked Frameworks and Libraries` 里面

## 使用说明

### 在 Storyboard 里面使用

拖一个 UIView 到 Storyboard，然后设置 `Custom Class` 为 `YXMenuView`

### 通过代码使用

```
import YXMenuView
menuView = YXMenuView(frame: CGRectMake(0, 60, view.frame.size.width, 44))
```

## Delegate 和 DataSource

### 必需

* `func numberOfSectionsInYXMenuView(menuView: YXMenuView) -> Int`
* `func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int`
* `func menuView(menuView: YXMenuView,  titleForHeaderInSection section: Int) -> String`
* `func menuView(menuView: YXMenuView,  titleForRowAtIndexPath indexPath: NSIndexPath) -> String`

### 可选

* `optional func menuView(menuView: YXMenuView, didSelectRowAtIndexPath indexPath: NSIndexPath)`
* `optional func heightForBodyView(menuView: YXMenuView) -> CGFloat`
* `optional func imageForSectionView(menuView: YXMenuView) -> UIImage?`


## TODO

* 支持 CocoaPods 安装

## 更多详情

[开发小记](https://blog.windisco.com/yxmenuview/)

# YXMenuView

MenuView for filtering data

![YXMenuViewDemo](http://windisco.qiniudn.com/YXMenuViewDemo.gif)

### Version 1.1

## Requirements
* Swift 2.1
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 8.0 or higher (May work on previous versions, just did not testit. Feel free to edit it).
* ARC

## Demo

Open and run the YXMenuViewDemo project in Xcode.

## Installation

### CocoaPods

not support yet.

### Manual install

1. drop YXMenuVIew folder into your project and include headers.
2. add framework into **both** `Embedded Binaries` and `Linked Frameworks and Libraries`


## Example usage

### Init With Storyboard

Drag a UIVIew into Storyboard, and set  `Custom Class` as `YXMenuView`.

### Init With Frame
```
import YXMenuView
menuView = YXMenuView(frame: CGRectMake(0, 60, view.frame.size.width, 44))
```

## Delegate and DataSource

### required

* `func numberOfSectionsInYXMenuView(menuView: YXMenuView) -> Int`
* `func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int`
* `func menuView(menuView: YXMenuView,  titleForHeaderInSection section: Int) -> String`
* `func menuView(menuView: YXMenuView,  titleForRowAtIndexPath indexPath: NSIndexPath) -> String`



### optional

* `optional func menuView(menuView: YXMenuView, didSelectRowAtIndexPath indexPath: NSIndexPath)`
* `optional func heightForTableView(menuView: YXMenuView) -> CGFloat`
* `optional func imageForSectionView(menuView: YXMenuView) -> UIImage?`

## TODO

* CocoaPods support

## More Details

[dev post chinese](https://blog.windisco.com/yxmenuview/)

## Chinese Readme

[README_CN](./README_CN.md)
<p align="left">
<a href="https://travis-ci.org/EurekaCommunity/ImageRow"><img src="https://travis-ci.org/EurekaCommunity/ImageRow.svg?branch=master" alt="Build status" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://cocoapods.org/pods/ImageRow"><img src="https://img.shields.io/cocoapods/v/ImageRow.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/EurekaCommunity/ImageRow/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [Xmartlabs SRL](http://EurekaCommunity.com).

## Introduction

ImageRow is a Eureka custom row that allows us to take or choose a picture.

<img src="Example/ImageRow.gif" width="300"/>

## Usage

```swift
import ImageRow
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        form +++ Section()
                <<< ImageRow() { row in
                    row.title = "Image Row 1"
                    row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                    row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                }
             +++
                Section()
                <<< ImageRow() {
                    $0.title = "Image Row 2"
                    $0.sourceTypes = .PhotoLibrary
                    $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
             +++
                 Section()
                    <<< ImageRow() {
                        $0.title = "Image Row 3"
                        $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                        $0.clearAction = .yes(style: .default)
                    }
    }
}

```

You must add the **NSPhotoLibraryUsageDescription**  and **NSCameraUsageDescription** keys to your info.plist to use the Photo Library and camera. For more information, take a look at apple [documentation](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html).

## Requirements

* iOS 9.0+
* Xcode 9.0+
* Eureka ~> 4.0

## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you **found a bug** or **need help** please **check older issues, [FAQ](#faq) before submitting an issue.**.

Before contribute check the [CONTRIBUTING](https://github.com/EurekaCommunity/ImageRow/blob/master/CONTRIBUTING.md) file for more info.

If you use **ImageRow** in your app We would love to hear about it! Drop us a line on [twitter](https://twitter.com/xmartlabs).

## Examples

Follow these 3 steps to run Example project: Clone ImageRow repository, run `carthage update` from project root folder, open ImageRow workspace and run the *Example* project.

You can also experiment and learn with the *ImageRow Playground* which is contained in *ImageRow.workspace*.

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install ImageRow, simply add the following line to your Podfile:

```ruby
pod 'ImageRow', '~> 3.0'
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install ImageRow, simply add the following line to your Cartfile:

```ogdl
github "EurekaCommunity/ImageRow" ~> 3.0
```

## Customization

ImageRow has 5 properties to customize:

* `sourceTypes` which allows us to specify the source of the picture. It could be .PhotoLibrary, .Camera, .SavedPhotosAlbum, or any combination of the previous values since `sourceTypes` property type is `ImageRowSourceTypes` which conforms to `OptionSet`.
* `clearAction` let's us add a clear action sheet option  and configure its style. Possible values are: `.no` or `.yes(style: UIAlertActionStyle)`. Notice that .yes value requires we pass a `UIAlertActionStyle` style.
* `allowEditor` tells the `ImagePickerController` to use the standard system image editor after a Image is selected. Possible values are: `true` or `false`. The default value for this property is `false`.
* `useEditedImage` tells the `ImageRow` to use the edited Image from the editor instead of the original one. Possible values are: `true` or `false`. The default value for this property is `false`.
* `userPickerInfo` this property holds the `info` properties of the `ImagePickerController` after a edited Image is selected, this can be used to further customization or information usage of the selected image. By default this property is `nil`.

To localize the Actionsheet strings just add the keys `"Take photo", "Photo Library", "Saved Photos", "Cancel", "Clear Photo"` to your Localizable.strings file

## Author

* [Xmartlabs SRL](https://github.com/xmartlabs) ([@xmartlabs](https://twitter.com/xmartlabs))

# Change Log

This can be found in the [CHANGELOG.md](CHANGELOG.md) file.

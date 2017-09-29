//  ImageRow.swift
//  ImageRow ( https://github.com/EurekaCommunity/ImageRow )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Eureka
import Foundation

public struct ImageRowSourceTypes: OptionSet {
    public let rawValue: Int
    public var imagePickerControllerSourceTypeRawValue: Int { return self.rawValue >> 1 }

    public init(rawValue: Int) { self.rawValue = rawValue }
    init(_ sourceType: UIImagePickerControllerSourceType) { self.init(rawValue: 1 << sourceType.rawValue) }

    public static let PhotoLibrary = ImageRowSourceTypes(.photoLibrary)
    public static let Camera = ImageRowSourceTypes(.camera)
    public static let SavedPhotosAlbum = ImageRowSourceTypes(.savedPhotosAlbum)
    public static let All: ImageRowSourceTypes = [Camera, PhotoLibrary, SavedPhotosAlbum]
}

extension ImageRowSourceTypes {
    var localizedString: String {
        switch self {
        case ImageRowSourceTypes.Camera:
            return NSLocalizedString("Take photo", comment: "") 
        case ImageRowSourceTypes.PhotoLibrary:
            return NSLocalizedString("Photo Library", comment: "") 
        case ImageRowSourceTypes.SavedPhotosAlbum:
            return NSLocalizedString("Saved Photos", comment: "") 
        default:
            return ""
        }
    }
}

public enum ImageClearAction {
    case no
    case yes(style: UIAlertActionStyle)
}

protocol ImageRowProtocol {
    var placeholderImage: UIImage? { get }
}

//MARK: Row

open class _ImageRow<Cell: CellType>: OptionsRow<Cell>, PresenterRowType, ImageRowProtocol where Cell: BaseCell, Cell.Value == UIImage {
  public typealias PresenterRow = ImagePickerController

  /// Defines how the view controller will be presented, pushed, etc.
  open var presentationMode: PresentationMode<PresenterRow>?

  /// Will be called before the presentation occurs.
  open var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?

  open var sourceTypes: ImageRowSourceTypes
  open var imageURL: URL?
  open var clearAction = ImageClearAction.yes(style: .destructive)
  open var placeholderImage: UIImage?

  private var _sourceType: UIImagePickerControllerSourceType = .camera

  public required init(tag: String?) {
    sourceTypes = .All
    super.init(tag: tag)

    presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return ImagePickerController() }, onDismiss: { [weak self] vc in
      self?.select()
      vc.dismiss(animated: true)
    })

    self.displayValueFor = nil
  }

  // copy over the existing logic from the SelectorRow
  func displayImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
    if let presentationMode = presentationMode, !isDisabled {
      if let controller = presentationMode.makeController(){
        controller.row = self
        controller.sourceType = sourceType
        onPresentCallback?(cell.formViewController()!, controller)
        presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
      } else {
        _sourceType = sourceType
        presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
      }
    }
  }

  /// Extends `didSelect` method
  /// Selecting the Image Row cell will open a popup to choose where to source the photo from,
  /// based on the `sourceTypes` configured and the available sources.
  open override func customDidSelect() {
    guard !isDisabled else {
      super.customDidSelect()
      return
    }

    deselect()

    var availableSources: ImageRowSourceTypes = []

    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let _ = availableSources.insert(.PhotoLibrary)
    }
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let _ = availableSources.insert(.Camera)
    }
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      let _ = availableSources.insert(.SavedPhotosAlbum)
    }

    sourceTypes.formIntersection(availableSources)

    if sourceTypes.isEmpty {
      super.customDidSelect()
      guard let presentationMode = presentationMode else { return }

      if let controller = presentationMode.makeController() {
        controller.row = self
        controller.title = selectorTitle ?? controller.title
        onPresentCallback?(cell.formViewController()!, controller)
        presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
      } else {
        presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
      }

      return
    }

    // Now that we know the number of sources aren't empty, let the user select the source
    let sourceActionSheet = UIAlertController(title: nil, message: selectorTitle, preferredStyle: .actionSheet)

    guard let tableView = cell.formViewController()?.tableView  else { fatalError() }

    if let popView = sourceActionSheet.popoverPresentationController {
      popView.sourceView = tableView
      popView.sourceRect = tableView.convert(cell.accessoryView?.frame ?? cell.contentView.frame, from: cell)
    }

    createOptionsForAlertController(sourceActionSheet)

    if case .yes(let style) = clearAction, value != nil {
      let clearPhotoOption = UIAlertAction(title: NSLocalizedString("Clear Photo", comment: ""), style: style) { [weak self] _ in
        self?.value = nil
        self?.imageURL = nil
        self?.updateCell()
      }

      sourceActionSheet.addAction(clearPhotoOption)
    }

    if sourceActionSheet.actions.count == 1 {
      if let imagePickerSourceType = UIImagePickerControllerSourceType(rawValue: sourceTypes.imagePickerControllerSourceTypeRawValue) {
        displayImagePickerController(imagePickerSourceType)
      }
    } else {
      let cancelOption = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)

      sourceActionSheet.addAction(cancelOption)

      if let presentingViewController = cell.formViewController() {
        presentingViewController.present(sourceActionSheet, animated: true)
      }
    }
  }

  /**
   Prepares the pushed row setting its title and completion callback.
   */
  open override func prepare(for segue: UIStoryboardSegue) {
    super.prepare(for: segue)
    guard let rowVC = segue.destination as? PresenterRow else { return }
    rowVC.title = selectorTitle ?? rowVC.title
    rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
    onPresentCallback?(cell.formViewController()!, rowVC)
    rowVC.row = self
    rowVC.sourceType = _sourceType
  }
}

extension _ImageRow {
    func createOptionForAlertController(_ alertController: UIAlertController, sourceType: ImageRowSourceTypes) {
        guard let pickerSourceType = UIImagePickerControllerSourceType(rawValue: sourceType.imagePickerControllerSourceTypeRawValue), sourceTypes.contains(sourceType) else { return }

        let option = UIAlertAction(title: NSLocalizedString(sourceType.localizedString, comment: ""), style: .default) { [weak self] _ in
            self?.displayImagePickerController(pickerSourceType)
        }

        alertController.addAction(option)
    }
    
    func createOptionsForAlertController(_ alertController: UIAlertController) {
        createOptionForAlertController(alertController, sourceType: .Camera)
        createOptionForAlertController(alertController, sourceType: .PhotoLibrary)
        createOptionForAlertController(alertController, sourceType: .SavedPhotosAlbum)
    }
}

/// A selector row where the user can pick an image
public final class ImageRow: _ImageRow<ImageCell>, RowType {
  public required init(tag: String?) {
    super.init(tag: tag)
  }
}

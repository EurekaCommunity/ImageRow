//
//  ViewController.swift
//  Example
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import ImageRow
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        form +++ Section()
                <<< ImageRow() { row in
                    row.title = "Image Row 1"
                    row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                    row.clearAction = .yes(style: UIAlertActionStyle.destructive)
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
                    <<< MyImageRow() {
                        $0.title = "Image Row 3"
                        $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                        $0.clearAction = .yes(style: .default)
                    }
    }
}

/// CustomPickerController: a selector row where the user can pick an image and edit it then of the selection
public final class MyImageRow : _ImageRow<CustomPickerController, MyImageCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        
        // Set a nib file to the cell privider
        cellProvider = CellProvider(nibName: "CustomRow")
    }
}

/// Definition of a custom cell
public final class MyImageCell: Cell<UIImage>, CellType {
    
    /// xib outlets
    @IBOutlet weak public var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    /// Required inits
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        fatalError("init(style:reuseIdentifier:) has not been implemented")
    }
    
    /// Override the setup to change the cell height
    public override func setup() {
        super.setup()
        
        height = { return 80 }
    }
    
    /// Cell update - The image selected in the row will appear in the imageView (outlet)
    public override func update() {
        super.update()
        
        if let image = row.value {
            myImageView.image = image
        }
        myLabel.text = row.title
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
}

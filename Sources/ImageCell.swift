//  ImageCell.swift
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

public final class ImageCell: PushSelectorCell<UIImage> {
    public override func setup() {
        super.setup()
        
        accessoryType = .none
        editingAccessoryView = .none

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        accessoryView = imageView
        editingAccessoryView = imageView
    }
    
    public override func update() {
        super.update()
        
        selectionStyle = row.isDisabled ? .none : .default
        (accessoryView as? UIImageView)?.image = row.value ?? (row as? ImageRowProtocol)?.placeholderImage
        (editingAccessoryView as? UIImageView)?.image = row.value ?? (row as? ImageRowProtocol)?.placeholderImage
    }
}

/*
MIT License

Copyright (c) 2020 Eyad Murshid

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

class AccessoryTouchBarSelectionCell: UICollectionViewCell {
    private var imageView: UIImageView!
    
    var title: String!
    var identifier: TouchBarButtonIdentifier?
    var cellLabel: UILabel!
    var viewConstrains: [NSLayoutConstraint] = []
    
    override var reuseIdentifier: String? { return "AccessoryTouchBarSelectionCell" }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    private func sharedInit() {
        imageView = {
            let imgView = UIImageView()
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.contentMode = .scaleAspectFill
            return imgView
        }()
        
        cellLabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textColor = .black
            return lbl
        }()
        
        let stackView = UIStackView(frame: bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(cellLabel)
        
        let screenSize = UIScreen.main.fixedCoordinateSpace.bounds
        
        contentView.addSubview(stackView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = screenSize.width * 0.02
        contentView.layer.cornerCurve = .continuous
        
        viewConstrains = [
            contentView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0.0),
            contentView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -15.0),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 15.0),
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0)
        ]
        
        NSLayoutConstraint.activate(viewConstrains)
    }
    
    func apply(label text: String, image name: String? = nil, appearance: TouchBarAppearance, identifier: TouchBarButtonIdentifier? = nil) {
        title = text
        self.identifier = identifier
        
        imageView.isHidden = (name == nil)
        
        if appearance == .light {
            if let imgName = name {
                imageView.image = UIImage(systemName: imgName, withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
                imageView.tintColor = .darkGray
            }
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            cellLabel.textColor = .black
        } else {
            if let imgName = name {
                imageView.image = UIImage(systemName: imgName, withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
                imageView.tintColor = .white
            }
            contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            cellLabel.textColor = .white
        }
        cellLabel.text = text
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        let targetSize = CGSize(width: 0, height: layoutAttributes.frame.height)
        
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.defaultLow, verticalFittingPriority: UILayoutPriority.required)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)
        
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
}

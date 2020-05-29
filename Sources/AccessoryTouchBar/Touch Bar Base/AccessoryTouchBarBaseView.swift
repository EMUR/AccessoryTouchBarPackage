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

class AccessoryTouchBarBaseView: UIView {
    open var activeTheme: TouchBarAppearance!
    weak var textField: UITextField?
    weak var textView: UITextView?
    open var data: [TouchBarButton]! { [] }
    open var delegate: AccessoryTouchBarNavigationDelegate?
    
    init(textField: UITextField? = nil, textView: UITextView? = nil, frame: CGRect, appearance: TouchBarAppearance, delegate: AccessoryTouchBarNavigationDelegate?) {
        super.init(frame: frame)
        self.textField = textField
        self.textView = textView
        self.activeTheme = appearance
        self.delegate = delegate
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = .zero
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = CGSize(width: self.bounds.width * 0.2, height: self.bounds.height * 0.76)
            return layout
        }()
        
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(AccessoryTouchBarSelectionCell.self, forCellWithReuseIdentifier: "AccessoryTouchBarSelectionCell")
        return collection
    }()
    
    func setupViewConstrains() {
        if let superView = superview { frame.size = superView.frame.size }
        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.93),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViewConstrains()
        super.layoutSubviews()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
    func animateSelectionFor(cell: AccessoryTouchBarSelectionCell, action: @escaping () -> ()) {
        selectionGenerator.prepare()
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.calculationModeCubicPaced, .allowUserInteraction, .beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                cell.transform = .init(scaleX: 0.97, y: 0.97)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                cell.transform = .init(scaleX: 1.0, y: 1.0)
            }
        })
        
        CATransaction.setCompletionBlock { selectionGenerator.selectionChanged(); action() }
        CATransaction.commit()
    }
    
    deinit { self.delegate = nil }
}

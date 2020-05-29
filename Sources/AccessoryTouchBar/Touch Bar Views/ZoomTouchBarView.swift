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

class ZoomView: UIView {
    open var activeTheme: TouchBarAppearance!
    weak var textField: UITextField?
    weak var textView: UITextView?
    open var delegate: AccessoryTouchBarNavigationDelegate?
    
    init(for textField: UITextField?, for textView: UITextView?, frame: CGRect, appearance: TouchBarAppearance, delegate: AccessoryTouchBarNavigationDelegate?) {
        super.init(frame: frame)
        self.textField = textField
        self.textView = textView
        self.activeTheme = appearance
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var zoomedTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.showsHorizontalScrollIndicator = false
        textView.text = self.textField?.text ?? self.textView?.text ?? ""
        textView.font = UIFont.systemFont(ofSize: 26.0)
        textView.delegate = self
        textView.becomeFirstResponder()
        return textView
    }()
    
    func setupViewConstrains() {
        if let superView = superview { frame.size = superView.frame.size }
        NSLayoutConstraint.activate([
            zoomedTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            zoomedTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            zoomedTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.93),
            zoomedTextField.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        addSubview(zoomedTextField)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViewConstrains()
        super.layoutSubviews()
    }
    
    deinit {
        zoomedTextField.delegate = nil
        self.delegate = nil
    }
}

extension ZoomView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textField?.text = textView.text
        self.textView?.text = textView.text
    }
}

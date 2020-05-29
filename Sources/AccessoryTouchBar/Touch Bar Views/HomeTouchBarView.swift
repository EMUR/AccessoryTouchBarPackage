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

class HomeView: AccessoryTouchBarBaseView {
    private var viewData: [TouchBarButton]! = []
    override var data: [TouchBarButton]! { viewData }
    
    init(options: [HomeViewIdentifier], textField: UITextField? = nil, textView: UITextView? = nil, frame: CGRect, appearance: TouchBarAppearance, delegate: AccessoryTouchBarNavigationDelegate?) {
        
        super.init(textField: textField, textView: textView, frame: frame, appearance: appearance, delegate: delegate)
        
        options.forEach {
            switch $0 {
            case .clearField:
                viewData.append(TouchBarButton(title: "Clear Text", image: "tornado", identifier: HomeViewIdentifier.clearField))
            case .copyToClipboard:
                viewData.append(TouchBarButton(title: "Copy Text", image: "doc.on.doc", identifier: HomeViewIdentifier.copyToClipboard))
            case .numberPad:
                viewData.append(TouchBarButton(title: "Numberpad", image: "number.square", identifier: HomeViewIdentifier.numberPad))
            case .pasteFromClipboard:
                viewData.append(TouchBarButton(title: "Paste Text", image: "doc.on.clipboard", identifier: HomeViewIdentifier.pasteFromClipboard))
            case .hashText:
                viewData.append(TouchBarButton(title: "Hash Text", image: "lock.shield", identifier: HomeViewIdentifier.hashText))
            case .hideKeyboard:
                viewData.append(TouchBarButton(title: "Hide Keyboard", image: "keyboard.chevron.compact.down", identifier: HomeViewIdentifier.hideKeyboard))
            case .todaysDate:
                viewData.append(TouchBarButton(title: "Today's Date", image: "calendar", identifier: HomeViewIdentifier.todaysDate))
            case .formatText:
                viewData.append(TouchBarButton(title: "Format Text", image: "textformat", identifier: HomeViewIdentifier.formatText))
            case .emailDomains:
                viewData.append(TouchBarButton(title: "Email Domains", image: "envelope", identifier: HomeViewIdentifier.emailDomains))
            case .zoom:
                viewData.append(TouchBarButton(title: "Zoom", image: "magnifyingglass", identifier: HomeViewIdentifier.zoom))
            case .emojis:
                viewData.append(TouchBarButton(title: "Emojis", image: "smiley", identifier: HomeViewIdentifier.emojis))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryTouchBarSelectionCell", for: indexPath) as! AccessoryTouchBarSelectionCell
        let touchBarButton = data[indexPath.row]
        cell.apply(label: touchBarButton.title, image: touchBarButton.image, appearance: activeTheme, identifier: touchBarButton.identifier)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AccessoryTouchBarSelectionCell {
            animateSelectionFor(cell: cell) {
                if let identifier = cell.identifier as? HomeViewIdentifier {
                    switch identifier {
                    case .clearField:
                        self.textField?.text = nil
                        self.textView?.text = nil
                    case .copyToClipboard:
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = self.textField?.text ?? self.textView?.text
                    case .emailDomains:
                        self.delegate?.navigate(to: .Email)
                    case .emojis:
                        self.delegate?.navigate(to: .Emojis)
                    case .hashText:
                        self.delegate?.navigate(to: .Hash)
                    case .hideKeyboard:
                        _ = self.textField?.resignFirstResponder()
                        _ = self.textView?.resignFirstResponder()
                    case .pasteFromClipboard:
                        let pasteboard = UIPasteboard.general
                        if let string = pasteboard.string {
                            self.textField?.text? += string
                            self.textView?.text += string
                        }
                    case .zoom:
                        self.delegate?.navigate(to: .Zoom)
                    case .numberPad:
                        self.delegate?.navigate(to: .NumberPad)
                    case .todaysDate:
                        self.delegate?.navigate(to: .TodaysDay)
                    case .formatText:
                        self.delegate?.navigate(to: .FormatText)
                    }
                }
            }
        }
    }
}

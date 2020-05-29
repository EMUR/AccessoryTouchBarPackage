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
import CryptoKit

class HashView: AccessoryTouchBarBaseView {
    override var data: [TouchBarButton]! {
        [TouchBarButton(title: "SHA256", identifier: HashViewIdentifier.SHA256),
         TouchBarButton(title: "SHA384", identifier: HashViewIdentifier.SHA384),
         TouchBarButton(title: "SHA512", identifier: HashViewIdentifier.SHA512),
         TouchBarButton(title: "MD5", identifier: HashViewIdentifier.MD5)]
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension HashView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryTouchBarSelectionCell", for: indexPath) as! AccessoryTouchBarSelectionCell
        let touchBarButton = data[indexPath.row]
        cell.apply(label: touchBarButton.title, appearance: activeTheme, identifier: touchBarButton.identifier)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AccessoryTouchBarSelectionCell {
            animateSelectionFor(cell: cell) {
                let dataEntryIdentifier = self.data[indexPath.row].identifier
                guard let currentText = (self.textField?.text ?? self.textView?.text) else { return }
                if currentText.count < 1 { return }
                let currentTextData = Data(currentText.utf8)
                
                if let identifier = dataEntryIdentifier as? HashViewIdentifier {
                    var hashedText = ""
                    
                    switch identifier {
                    case .SHA256:
                        hashedText = SHA256.hash(data: currentTextData).description
                    case .SHA384:
                        hashedText = SHA384.hash(data: currentTextData).description
                    case .SHA512:
                        hashedText = SHA512.hash(data: currentTextData).description
                    case .MD5:
                        hashedText = Insecure.MD5.hash(data: currentTextData).description
                    }
                    
                    let hashString = hashedText.compactMap { String(format: "%02x", "\($0)") }.joined()
                    self.textField?.text = hashString
                    self.textView?.text = hashString
                }
            }
        }
    }
}

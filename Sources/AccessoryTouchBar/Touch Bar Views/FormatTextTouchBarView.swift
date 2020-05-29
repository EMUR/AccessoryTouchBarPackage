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

class FormatTextView: AccessoryTouchBarBaseView {
    override var data: [TouchBarButton]! {
        [TouchBarButton(title: "First Char Cap", identifier: FormatViewIdentifier.caps),
         TouchBarButton(title: "RemoveWhiteSpace", identifier: FormatViewIdentifier.removeWhitespace),
         TouchBarButton(title: "[Wrap Text in Brackets]", identifier: FormatViewIdentifier.wrapInBrackets)]
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FormatTextView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryTouchBarSelectionCell", for: indexPath) as! AccessoryTouchBarSelectionCell
        cell.apply(label: data[indexPath.row].title, image: data[indexPath.row].image, appearance: activeTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AccessoryTouchBarSelectionCell {
            animateSelectionFor(cell: cell) {
                let dataEntryIdentifier = self.data[indexPath.row].identifier
                if let identifier = dataEntryIdentifier as? FormatViewIdentifier {
                    let dataString = self.textField?.text ?? self.textView?.text
                    switch identifier {
                    case .caps:
                        let allCaps = dataString?.components(separatedBy: CharacterSet.whitespacesAndNewlines).map { String($0.prefix(1).capitalized + $0.dropFirst()) }.joined(separator: " ")
                        
                        self.textField?.text = allCaps
                        self.textView?.text = allCaps
                    case .removeWhitespace:
                        let removeWhitespace = dataString?.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined()
                        
                        self.textField?.text = removeWhitespace
                        self.textView?.text = removeWhitespace
                    case .wrapInBrackets:
                        self.textField?.text? = "[\(dataString ?? "")]"
                        self.textView?.text = "[\(dataString ?? "")]"
                    }
                }
            }
        }
    }
}

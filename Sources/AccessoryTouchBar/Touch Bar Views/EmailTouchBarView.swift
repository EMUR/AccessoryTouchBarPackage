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

class EmailDomainsView: AccessoryTouchBarBaseView {
    override var data: [TouchBarButton]! {
        [TouchBarButton(title: "@apple.com"),
         TouchBarButton(title: "@gmail.com"),
         TouchBarButton(title: "@yahoo.com"),
         TouchBarButton(title: "@live.com"),
         TouchBarButton(title: "@mail.ru"),
         TouchBarButton(title: "@icould.com")]
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension EmailDomainsView: UICollectionViewDataSource, UICollectionViewDelegate {
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
                if let currentText = self.textField?.text ?? self.textView?.text {
                    if currentText.last == "@" {
                        let dataString = currentText + String(self.data[indexPath.row].title.dropFirst())
                        self.textField?.text = dataString
                        self.textView?.text = dataString
                    } else {
                        let dataString = currentText + self.data[indexPath.row].title
                        self.textField?.text = dataString
                        self.textView?.text = dataString
                    }
                }
            }
        }
    }
}

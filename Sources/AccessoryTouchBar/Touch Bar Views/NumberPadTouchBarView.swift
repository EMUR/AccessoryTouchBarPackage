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

class NumberPadView: AccessoryTouchBarBaseView {
    override var data: [TouchBarButton]! {
        [TouchBarButton(title: "1"),
         TouchBarButton(title: "2"),
         TouchBarButton(title: "3"),
         TouchBarButton(title: "4"),
         TouchBarButton(title: "5"),
         TouchBarButton(title: "6"),
         TouchBarButton(title: "7"),
         TouchBarButton(title: "8"),
         TouchBarButton(title: "9"),
         TouchBarButton(title: "0")]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDigitsConstrains()
        super.layoutSubviews()
    }
    
    func setupDigitsConstrains() {
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = .zero
            layout.scrollDirection = .horizontal
            
            let spacing: CGFloat = 5.0
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = spacing
            
            let dataCount = CGFloat(data.count)
            layout.itemSize = CGSize(width: (self.bounds.width * 0.93) / dataCount - (spacing * (2.0 / ((dataCount / 2.0) - 3.0))), height: self.bounds.height * 0.9)
            return layout
        }()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension NumberPadView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryTouchBarSelectionCell", for: indexPath) as! AccessoryTouchBarSelectionCell
        
        cell.viewConstrains.first(where: { $0.firstAttribute == .leading })?.constant = 0.0
        cell.viewConstrains.first(where: { $0.firstAttribute == .trailing })?.constant = 0.0
        
        cell.cellLabel.textAlignment = .center
        cell.cellLabel.font = UIFont.systemFont(ofSize: 24.0)
        
        cell.apply(label: data[indexPath.row].title, appearance: activeTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AccessoryTouchBarSelectionCell {
            animateSelectionFor(cell: cell) {
                self.textField?.text? += self.data[indexPath.row].title
                self.textView?.text? += self.data[indexPath.row].title
            }
        }
    }
}

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

import CryptoKit
import UIKit

let selectionGenerator = UISelectionFeedbackGenerator()

enum AccessoryTouchBarViewType {
    case Home
    case Email
    case Emojis
    case Hash
    case Zoom
    case NumberPad
    case TodaysDay
    case FormatText
}

protocol AccessoryTouchBarNavigationDelegate {
    func navigate(to view: AccessoryTouchBarViewType)
}

class AccessoryTouchBar: UIView {
    private var activeTheme: TouchBarAppearance!
    private weak var presentedView: UIView?
    private var baseScrollView: UIScrollView!
    private var mainViewOptions:[HomeViewIdentifier]!
    private var blurBackgroud:UIVisualEffectView!
    weak var textField: UITextField?
    weak var textView: UITextView?
    
    convenience init(for textField: UITextField, options: [HomeViewIdentifier]) {
        let screenSize = UIScreen.main.fixedCoordinateSpace.bounds
        self.init(frame: .init(origin: .zero, size: .init(width: screenSize.width, height: screenSize.height * 0.06)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccessoryTouchBar.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.textField = textField
        setupViews(with: options)
    }
    
    convenience init(for textView: UITextView, options: [HomeViewIdentifier]) {
        let screenSize = UIScreen.main.fixedCoordinateSpace.bounds
        self.init(frame: .init(origin: .zero, size: .init(width: screenSize.width, height: screenSize.height * 0.06)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccessoryTouchBar.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.textView = textView
        setupViews(with: options)
    }
    
    private func setupViews(with options:[HomeViewIdentifier]) {
        
        self.mainViewOptions = options
        
        blurBackgroud = UIVisualEffectView()
        blurBackgroud.translatesAutoresizingMaskIntoConstraints = false
        blurBackgroud.backgroundColor = .clear
        addSubview(blurBackgroud)
        
        NSLayoutConstraint.activate([
            blurBackgroud.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0),
            blurBackgroud.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0),
            blurBackgroud.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurBackgroud.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        baseScrollView = UIScrollView()
        baseScrollView.translatesAutoresizingMaskIntoConstraints = false
        baseScrollView.backgroundColor = .clear
        
        addSubview(baseScrollView)
        NSLayoutConstraint.activate([
            baseScrollView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0),
            baseScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0),
            baseScrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            baseScrollView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        baseScrollView.alwaysBounceVertical = true
        baseScrollView.delegate = self
    }
    
    
    private func setupAppearence(){
        if let keyboardAppearence = textField?.keyboardAppearance ?? textView?.keyboardAppearance {
            let activateLightTheme = {
                self.activeTheme = .light
                self.backgroundColor = lightColor.withAlphaComponent(0.45)
                self.blurBackgroud.effect = UIBlurEffect(style: .extraLight)
            }
            
            let activateDarkTheme = {
                self.activeTheme = .dark
                self.backgroundColor = darkColor.withAlphaComponent(0.5)
                self.blurBackgroud.effect = UIBlurEffect(style: .dark)
            }
            if keyboardAppearence == .default {
                var systemActiveColor:UIUserInterfaceStyle!
                let overriddenUI = UIApplication.shared.windows.first?.overrideUserInterfaceStyle
                if overriddenUI != .unspecified { systemActiveColor = overriddenUI }
                else{ systemActiveColor = UIScreen.main.traitCollection.userInterfaceStyle }
                
                if systemActiveColor == .light { activateLightTheme() }
                else { activateDarkTheme() }
            } else {
                let keyboardAppearence = textField?.keyboardAppearance ?? textView?.keyboardAppearance
                if keyboardAppearence == .light { activateLightTheme() }
                else { activateDarkTheme() }
            }
        }
    }
    
    func present(view: UIView) {
        let animationOffest: CGFloat = 10
        let delayMultiplier: Double = (presentedView != nil ? 1.0 : 0.0)
        
        view.alpha = 0.0
        view.frame.origin.y -= animationOffest * -1
        baseScrollView.addSubview(view)
        baseScrollView.isUserInteractionEnabled = false
        CATransaction.begin()
        baseScrollView.scrollRectToVisible(.zero, animated: true)
        UIView.animateKeyframes(withDuration: 0.33, delay: 0.0, options: [.calculationModeCubic, .allowUserInteraction, .beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                self.presentedView?.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2) {
                self.presentedView?.transform = CGAffineTransform(translationX: 0, y: animationOffest)
            }
            UIView.addKeyframe(withRelativeStartTime: delayMultiplier * 0.3, relativeDuration: 0.5) {
                view.transform = CGAffineTransform(translationX: 0, y: -1 * animationOffest)
                view.alpha = 1.0
                self.baseScrollView.backgroundColor = .clear
            }
        })
        CATransaction.setCompletionBlock {
            self.presentedView?.removeFromSuperview(); self.presentedView = view;
            self.baseScrollView.isUserInteractionEnabled = true
        }
        CATransaction.commit()
    }
    
    func dimsissPresentedView() {
        navigate(to: .Home)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil { return }
        setupAppearence()
        navigate(to: .Home)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        presentedView?.setNeedsLayout()
        layoutIfNeeded()
    }
}

extension AccessoryTouchBar: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.0 || presentedView is HomeView {
            scrollView.setContentOffset(.zero, animated: false)
        } else {
            let contentOffest = abs(scrollView.contentOffset.y)
            scrollView.backgroundColor = UIColor.red.withAlphaComponent(contentOffest / 50.0)
            if contentOffest >= 16.0 { navigate(to: .Home) }
        }
    }
}

extension AccessoryTouchBar: AccessoryTouchBarNavigationDelegate {
    func navigate(to view: AccessoryTouchBarViewType) {
        switch view {
        case .Home:
            present(view: HomeView(options: mainViewOptions, textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .Email:
            present(view: EmailDomainsView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .Emojis:
            present(view: EmojiView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .Hash:
            present(view: HashView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .Zoom:
            present(view: ZoomView(for: textField, for: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .NumberPad:
            present(view: NumberPadView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .TodaysDay:
            present(view: TodaysDateView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        case .FormatText:
            present(view: FormatTextView(textField: textField, textView: textView, frame: bounds, appearance: activeTheme, delegate: self))
        }
    }
}

<p align="center"> 
<img src="https://i.imgur.com/0uGtd2h.png" width="800px"/>
</p>

## 📃 Description:

A swift package that introduces the MacOS touchbar concept to iOS/iPadOS devices.

AccessoryTouchBar supports various functionalities such as, copying/pasting texts, clearing out text fields, formatting texts, dedicated numerpad, hiding the keyboard and many more.
</br>

## 🚀 Installation

### Swift Package Manager
Adding AccessoryTouchBar support to your app is very easy. You will just need to add this into the dependencies value of your ```Package.swift```.
```
dependencies: [
    .package(url: "https://github.com/EMUR/AccessoryTouchBarPackage.git", .upToNextMajor(from: "1.0.0"))
]
```

## 📲 Usage
The touchbar supports `UITextField` and `UITextView`, to add it to any of your app's text fields, you will simply just call `.addTouchBarSupport()` on your text field and the touchbar will be automatically added on top of the keyboard. 

</br>The following code is an example of a text field `myTextField` with touchbar support:

```swift
var myTextField = UITextField()
myTextField.addTouchBarSupport()
```

</br>By default, you text field will support all of the touchbar functionalities. To specify which options to present, you can simply specify that in the options parameter for the function, like the following:

```swift
var myTextView = UITextView()
myTextView.addTouchBarSupport(options: [.emailDomains, .zoom, .formatText, .hideKeyboard, .copyToClipboard, .pasteFromClipboard, .numberPad])
```

This will allow `myTextField` to only show the options specified, you can customize the options per text field to provide the best user experience.

☝️ *The package was build with modularity in mind, so you can create your own custom options and enhance existing ones.*

## ⭐️ Features/Examples:

<img src="https://i.imgur.com/nx15K1m.gif" width="300px"/>

> You can use the *Email Domains* option to quickly access common domains, tapping on any of them will autocomplete you field. Additionally, you can easily copy/paste any text in the field by easy to access buttons. To go back to the main menu, you just have to swipe down and the current view will be dismissed back to main.


</br>
</br>

<img src="https://i.imgur.com/apcT41o.gif" width="300px"/>

> An Always one number pad view is useful when you are computing tasks that needs both letters and digits, making it faster to access both simultaneously

</br>
</br>

<img src="https://i.imgur.com/JSwBaWo.gif" width="300px"/>

> Forgot what day is today? no problem, *Today's Date* is a convenient way of auto filling today's date with the format of your choice, making it just a bit faster than looking up and typing today's date.

</br>
</br>

<img src="https://i.imgur.com/QJUriYN.gif" width="300px"/>

> If you have ever felts that it's hard for you to read or scroll through the content of a text field, maybe the text is too small? or the font is not clear? The *Zoom* functionality is perfect for that. It will zoom in the text of the label and will allow you to edit the content with a much more clarity.

</br>
</br>

<img src="https://i.imgur.com/Nw77LRh.gif" width="300px"/>

> When dealing with a lot of text, you might want to start over, the *Clear Field* will make that possible with a tap of a button. You will also have access to all of your favorite emojis as well as well as a quick formatting functionalities, like *Make First Character Capital*. Additionally, you can also hash the content of the text field to SHA256, SHA384, SHA512 and MD5, because why not :stuck_out_tongue:

</br>
</br>

<img src="https://i.imgur.com/qYjgR9v.gif" width="300px"/>

> Of course, the touchbar will adapt based on the current keyboard look.

</br>
</br>

<img src="https://i.imgur.com/7C30mf3.gif" width="600px"/>

> The touchbar also supports Landscape mode.

## 👨🏻‍🎨 Author
Built with ❤︎ by [Eyad Murshid](https://www.linkedin.com/in/eyadmurshid/)

## 📒 License
This project is licensed under the MIT License - see the `LICENSE` file for details.

## 🙏 Acknowledgments
- Apple for SF Symbols (used fro TouchBar icons) and their awesome OS!
- Everyone who used it, forked it or favorite it!


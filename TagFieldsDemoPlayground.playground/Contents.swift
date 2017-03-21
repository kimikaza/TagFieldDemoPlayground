//: Playground - noun: a place where people can play

import UIKit
import QuartzCore
import PlaygroundSupport

class ViewController: UIViewController {

    let tokens = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen"];

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:1.00, green:0.63, blue:0.67, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view, typically from a nib.
        setupTextView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTextView() {
        let textView = TagView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        addTextToTextView(textView)
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor(red:0.71, green:0.86, blue:0.50, alpha:1.0)
        view.addSubview(textView)

        let bottom = NSLayoutConstraint(item: view,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: textView,
                                        attribute: .bottom,
                                        multiplier: 1, constant: 50)
        let left = NSLayoutConstraint(item: view,
                                        attribute: .leading,
                                        relatedBy: .equal,
                                        toItem: textView,
                                        attribute: .leading,
                                        multiplier: 1, constant: -100)
        let right = NSLayoutConstraint(item: view,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: textView,
                                        attribute: .trailing,
                                        multiplier: 1, constant: 100)

        NSLayoutConstraint.activate([bottom, left, right])
        textView.invalidateIntrinsicContentSize()
        view.layoutIfNeeded()
    }

    func addTextToTextView(_ textView: UITextView) {


        var delimiter = NSMutableAttributedString(string: "")
        let text = NSMutableAttributedString()

        let layoutManager = CustomLayoutManager()


        textView.textContainer.replaceLayoutManager(layoutManager)

        let paragraphStyle = NSMutableParagraphStyle()

        let font = UIFont.systemFont(ofSize: 12)

        paragraphStyle.lineSpacing = 0.7 * font.lineHeight

        tokens.forEach { (token) in
            let attrText = NSMutableAttributedString(string: token)
            attrText.addAttribute("RoundedBackgroundColorAttribute"/*NSBackgroundColorAttributeName*/,
                                  value: UIColor(red:0.48, green:0.53, blue:0.44, alpha:1),
                                  range: NSRange(location: 0, length: attrText.length))
            attrText.addAttribute(NSForegroundColorAttributeName,
                                  value: UIColor(red:1.00, green:1.00, blue:0.65, alpha:1.0), range: NSRange(location: 0, length: attrText.length))
            text.append(delimiter)
            text.append(attrText)
            delimiter = NSMutableAttributedString(string: "    ")
        }

        text.addAttribute(NSParagraphStyleAttributeName,
                          value: paragraphStyle,
                          range: NSRange(location: 0, length: text.length))

        textView.textContainerInset.top = 2
        textView.textContainerInset.bottom = 1
        textView.contentInset.left = 5
        textView.contentInset.right = 5

        textView.layer.cornerRadius = 4

        textView.attributedText = text
    }
}

class CustomLayoutManager: NSLayoutManager {

    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        let range = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        guard let textStorage = textStorage else {
            return
        }
        textStorage
            .enumerateAttribute("RoundedBackgroundColorAttribute",
                                in: range,
                                options: .longestEffectiveRangeNotRequired)
            { (value, range, objCBoolStop) in
                guard let value = value else {
                    super.drawGlyphs(forGlyphRange: range, at: origin)
                    return
                }
                guard let color = (value as? UIColor) else { return }
                let glRange = glyphRange(forCharacterRange: range, actualCharacterRange: nil);
                //UInt here is because otherwise playground does not want to execute, although compiler
                //is actually letting me know that this is wrong. However, this makes the playground work
                //if it doesn't work for you, try removing UInt wrapping here.
                guard let tContainer = textContainer(forGlyphAt: UInt(glRange.location),
                                                    effectiveRange: nil) else { return }
                //draw background rectangle
                guard let context = UIGraphicsGetCurrentContext() else { return }
                guard let font = currentFontFor(range: range) else {
                    return
                }
                context.saveGState()
                context.translateBy(x: origin.x, y: origin.y)
                color.setFill()
                var rect = boundingRect(forGlyphRange: glRange, in: tContainer)
                rect.origin.x = rect.origin.x - 5
                if(rect.origin.y == 0) {
                    rect.origin.y = rect.origin.y - 1
                } else {
                    rect.origin.y = rect.origin.y - 2
                }
                rect.size.width = rect.size.width + 10
                rect.size.height = font.lineHeight + 4

                let path = UIBezierPath(roundedRect: rect, cornerRadius: 6)
                path.fill()
                context.restoreGState()
                super.drawGlyphs(forGlyphRange: range, at: origin)
                
        }
        
    }

    func currentFontFor(range: NSRange) -> UIFont? {
        guard let textStorage = textStorage else {
            return nil
        }
        guard let font = textStorage.attributes(at: range.location, effectiveRange: nil)[NSFontAttributeName] as? UIFont else { return nil }
        return font
    }
}

class TagView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()

        if(self.bounds.size != self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }

    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = self.contentSize
        intrinsicContentSize.width += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        intrinsicContentSize.height += (self.textContainerInset.top + self.textContainerInset.bottom) / 2.0
        return intrinsicContentSize
    }
}

let VC = ViewController()

PlaygroundPage.current.liveView = VC






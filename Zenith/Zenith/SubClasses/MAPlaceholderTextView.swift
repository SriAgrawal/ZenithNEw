//
//  MAPlaceholderTextView.swift
//  MobileApp
//
//  Created by Raj Kumar Sharma on 20/10/15.
//  Copyright © 2015 Mobiloitte. All rights reserved.
//

import UIKit

protocol MAPlaceholderTextViewDelegate {
    func pressDone()
    func pressCancel()
    func pressCamera()
}

@IBDesignable
public class MAPlaceholderTextView: UITextView {
    
    var placeholderTextViewdelegate:MAPlaceholderTextViewDelegate?
    
    struct Constants {
        static let defaultiOSPlaceholderColor = UIColor.darkGray
    }
    
    @IBInspectable public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor = MAPlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    public let placeholderLabel: UILabel = UILabel()
    
    override public var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(MAPlaceholderTextView.textDidChange),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        self.textContainerInset = UIEdgeInsetsMake(25, 10, 10, 10); // top, left, bottom, right --> Padding, Additional line added
        
        updateConstraintsForPlaceholderLabel()
        
        self.addToolBar()
    }
    
    func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]-(\(textContainerInset.right + textContainer.lineFragmentPadding))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]-(>=\(textContainerInset.bottom))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    // adding tool bar start
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MAPlaceholderTextView.donePressed))
        doneButton.tintColor = UIColor(red: 86/255, green: 196/255, blue: 210/255, alpha: 1)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MAPlaceholderTextView.cancelPressed))
        cancelButton.tintColor = UIColor.darkGray

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, self.getCameraBarButton(), doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    private func getCameraBarButton() -> UIBarButtonItem {
        let cameraButton: UIButton = UIButton()
        cameraButton.setImage(UIImage(named: "camera_black_icon"), for: .normal)
      //  cameraButton.frame = CGRectMake(0, 50, 60, 40)
        cameraButton.imageEdgeInsets = UIEdgeInsetsMake(0 , 0, 0, 0)
        cameraButton.addTarget(self, action: #selector(MAPlaceholderTextView.cameraPressed), for: .touchUpInside)
        
        let barButton:UIBarButtonItem = UIBarButtonItem()
        barButton.customView = cameraButton
        
        return barButton
    }
    
    func donePressed(){
        self.resignFirstResponder()
        
        self.placeholderTextViewdelegate?.pressDone()
    }
    func cancelPressed(){
        self.text = ""
        self.placeholderTextViewdelegate?.pressCancel()
    }
    func cameraPressed(){
        self.placeholderTextViewdelegate?.pressCamera()
    }
    // adding tool bar end
    
    deinit {
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
    
}

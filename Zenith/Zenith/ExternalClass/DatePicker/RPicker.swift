//
//  RPicker.swift
//  Smoogin
//
//  Created by Raj Kumar Sharma on 05/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import UIKit

let pickerAnimationDuration: TimeInterval = 0.3
let viewTransperantTag: Int = 9099

class RPicker: NSObject {
    
    class func selectDate(datePickerMode: UIDatePickerMode = UIDatePickerMode.date,
                          selectedDate: Date? = Date(),
                          minDate: Date? = nil,
                          maxDate: Date? = nil,
                          didSelectDate : ((_ date: Date)->())?)  {

         if let currentController = kAppDelegate.window?.currentController {
            
            if let bgView = currentController.view.viewWithTag(viewTransperantTag) {
                return
            }
            
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = datePickerMode
            datePicker.backgroundColor = UIColor.white
            
            datePicker.minimumDate = minDate
            datePicker.maximumDate = maxDate

            if let selectedDate = selectedDate {
                datePicker.date = selectedDate
            } else {
                datePicker.date = Date()
            }
            
            //Screen Size
            let screenWidth = currentController.view.bounds.size.width
            let screenHeight = currentController.view.bounds.size.height
            let pickerHeight: CGFloat = 216

            // Add background view
            
            let closeFrame = CGRect(x: 0, y: screenHeight + 50, width: screenWidth, height: screenHeight)
            
            let viewTransperant = UIView(frame: closeFrame)
            viewTransperant.backgroundColor = UIColor.clear
            //viewTransperant.alpha = 0.0
            currentController.view.addSubview(viewTransperant)
            viewTransperant.tag = viewTransperantTag
            
            // Add date picker view

            let pickerY = screenHeight - pickerHeight
            
            let pickerFrame = CGRect(x: 0, y: pickerY, width: screenWidth, height: pickerHeight)
            datePicker.frame = pickerFrame
            viewTransperant.addSubview(datePicker)

            // Add tool bar with done and cancel buttons
            var toolBarFrame = CGRect(x: 0, y: pickerY, width: screenWidth, height: 40)
            toolBarFrame.origin.y = pickerY - toolBarFrame.size.height

            let toolBar = RToolBar(frame: toolBarFrame)
            
            viewTransperant.addSubview(toolBar)

            // show picker
            var openPickerFrame = viewTransperant.frame
            openPickerFrame.origin.y = 0
          
            UIView.animate(withDuration: pickerAnimationDuration, animations: {
                viewTransperant.frame = openPickerFrame

            }, completion: { (_) in
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0.6)
                })
            })
            
            
            toolBar.didSelectDone = {
                didSelectDate!(datePicker.date)
                remove()
            }
            
            toolBar.didCancelled = {
                
                remove()
            }
            
            
            func remove() {
                
                UIView.animate(withDuration: pickerAnimationDuration, animations: {
                    viewTransperant.backgroundColor = UIColor.clear
                    
                }, completion: { (_) in
                    UIView.animate(withDuration: pickerAnimationDuration, animations: {
                        viewTransperant.frame = closeFrame
                    }, completion: { (_) in
                        viewTransperant.removeFromSuperview()
                    })
                })
            }
        }
    }
}


class RToolBar: UIView {
    
    open var didSelectDone: (() -> Void)?
    open var didCancelled: (() -> Void)?

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(toolbar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    open var toolbar: UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(self.doneAction))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(self.cancelAction))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    func doneAction() {
        
        didSelectDone?()

        
    }
    
    func cancelAction() {
        didCancelled?()

    }
    
}




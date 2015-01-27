//
//  Dialogue.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/2/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit


class DialogueController {

    var controller: UIAlertController?

    init(title: String, message: String) {
        controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    }
    
    func addTextField(#placeholder: String) {
        addTextField(placeholder: placeholder, isSecure: false)
    }
    
    func addTextField(#placeholder: String, isSecure: Bool) {
        func setTextField(textField: UITextField!) {
            textField.placeholder = placeholder
            textField.secureTextEntry = isSecure
        }
        
        controller!.addTextFieldWithConfigurationHandler(setTextField)
    }
    
    func addAction(title: String, handler: (action:UIAlertAction!) -> Void) {
        controller!.addAction(
            UIAlertAction(
                title: title,
                style: UIAlertActionStyle.Default,
                handler: handler
            )
        )
    }
    
    func addCancelAction() {
        controller!.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil
            )
        )
    }
    
    func getTextFieldAtIndex(index: Int) -> String {
        return (controller!.textFields![index] as UITextField).text
    }
    
    func addPasswordField(#placeholder: String) {
        addTextField(placeholder: placeholder, isSecure: true)
    }
    
    func styleMessage(font: UIFont) {
        setFont(controller!.message!, font: font, key: "attributedMessage")
    }
    
    func styleTitle(font: UIFont) {
        setFont(controller!.title!, font: font, key: "attributedTitle")
    }
    
    func present(#context: UIViewController) {
        context.presentViewController(
            controller!,
            animated: true,
            completion: nil
        )
    }

    private
    func setFont(text: String, font: UIFont, key: String) {
        var title = NSMutableAttributedString(string: text)
        title.addAttribute(
            NSFontAttributeName,
            value: font,
            range: NSMakeRange(0, countElements(text))
        )
        
        //setAttributedMessage = title
    }
    
}
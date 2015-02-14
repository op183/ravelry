//
//  Dialogue.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/2/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit


class DialogueController: NSObject {

    var controller: UIAlertController
    
    init(title: String, message: String = "") {
        controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        super.init()
    }
    
    func addTextField(#placeholder: String) -> DialogueController {
        addTextField(placeholder: placeholder, isSecure: false)
        return self
    }
    
    func addTextField(#placeholder: String, isSecure: Bool) -> DialogueController {
        
        func setTextField(textField: UITextField!) {
            textField.placeholder = placeholder
            textField.secureTextEntry = isSecure
        }
        
        controller.addTextFieldWithConfigurationHandler(setTextField)
        return self
    }
    
    func addAction(title: String, handler: (action:UIAlertAction!) -> Void) -> DialogueController {
        controller.addAction(
            UIAlertAction(
                title: title,
                style: UIAlertActionStyle.Default,
                handler: handler
            )
        )
        
        return self
    }
    
    func addCancelAction() -> DialogueController {
        
        controller.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil
            )
        )
        
        return self
    }
    
    func getTextFieldAtIndex(index: Int) -> String {
        return (controller.textFields![index] as UITextField).text
    }
    
    func addPasswordField(#placeholder: String) -> DialogueController {
        addTextField(placeholder: placeholder, isSecure: true)
        return self
    }
    
    func styleMessage(font: UIFont) -> DialogueController {
        setFont(controller.message!, font: font, key: "attributedMessage")
        return self
    }
    
    func styleTitle(font: UIFont) -> DialogueController {
        setFont(controller.title!, font: font, key: "attributedTitle")
        return self
    }
    
    func present(#context: UIViewController) -> DialogueController {
        context.presentViewController(
            controller,
            animated: true,
            completion: nil
        )
        return self
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
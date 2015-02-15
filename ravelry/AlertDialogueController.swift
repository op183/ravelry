//
//  AlertDialogueController.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/14/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit


class AlertDialogueController: DialogueController {
    
    init(_ title: String, _ message: String = "") {
        super.init(title: title, message: message)

        addAction("OK") { (action) in
            println("Hiding Overlay")
            self.context!.hideOverlay()
        }
    }
}
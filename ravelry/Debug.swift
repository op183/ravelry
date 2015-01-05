//
//  Debug.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

func dumpFonts() {
    for familyName in UIFont.familyNames() {
        println(familyName)

        for font in UIFont.fontNamesForFamilyName(familyName as String) {
            println("\t\(font)")
        }
    }
}
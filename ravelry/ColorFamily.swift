//
//  ColorFamily.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/30/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum ColorFamily: Int {
    case Yellow = 1
    case YellowOrange = 2
    case Orange = 3
    case RedOrange = 4
    case Red = 5
    case RedPurple = 6
    case Purple = 7
    case BluePurple = 8
    case Blue = 9
    case BlueGreen = 10
    case Green = 11
    case YellowGreen = 12
    case Black = 13
    case White = 14
    case Gray = 15
    case Brown = 16
    case Pink = 17
    case NaturalUndyed = 18

    var id: Int {
        return self.rawValue
    }

    var name: String {
        switch self {
            case Yellow: return "Yellow"
            case YellowOrange: return "Yellow-orange"
            case Orange: return "Orange"
            case RedOrange: return "Red-orange"
            case Red: return "Red"
            case RedPurple: return "Red-purple"
            case Purple: return "Purple"
            case BluePurple: return "Blue-purple"
            case Blue: return "Blue"
            case BlueGreen: return "Blue-green"
            case Green: return "Green"
            case YellowGreen: return "Yellow-green"
            case Black: return "Black"
            case White: return "White"
            case Gray: return "Gray"
            case Brown: return "Brown"
            case Pink: return "Pink"
            case NaturalUndyed: return "Natural/Undyed"
        }
    }
    
    var permalink: String {
        switch self {
            case Yellow: return "Yellow"
            case YellowOrange: return "Yellow-orange"
            case Orange: return "Orange"
            case RedOrange: return "Red-orange"
            case Red: return "Red"
            case RedPurple: return "Red-purple"
            case Purple: return "Purple"
            case BluePurple: return "Blue-purple"
            case Blue: return "Blue"
            case BlueGreen: return "Blue-green"
            case Green: return "Green"
            case YellowGreen: return "Yellow-green"
            case Black: return "Black"
            case White: return "White"
            case Gray: return "Gray"
            case Brown: return "Brown"
            case Pink: return "Pink"
            case NaturalUndyed: return "Natural/Undyed"
        }
    }
    
    var color: String? {
        return nil
    }
    
    var spectrumOrder: Int {
        switch self {
            case Yellow: return 1
            case YellowOrange: return 2
            case Orange: return 3
            case RedOrange: return 4
            case Red: return 5
            case RedPurple: return 0
            case Purple: return 8
            case BluePurple: return 9
            case Blue: return 10
            case BlueGreen: return 11
            case Green: return 12
            case YellowGreen: return 13
            case Black: return 14
            case White: return 15
            case Gray: return 16
            case Brown: return 17
            case Pink: return 18
            case NaturalUndyed: return 19
        }
    }
    
    static let all: [ColorFamily] = [
        .Yellow,
        .YellowOrange,
        .Orange,
        .RedOrange,
        .Red,
        .RedPurple,
        .Purple,
        .BluePurple,
        .Blue,
        .BlueGreen,
        .Green,
        .YellowGreen,
        .Black,
        .White,
        .Gray,
        .Brown,
        .Pink,
        .NaturalUndyed
    ]
    
    static var descriptions: [String] {
        var colorFamilyDescriptions = [String]()
        for cf in ColorFamily.all {
            colorFamilyDescriptions.append(cf.name)
        }
        return colorFamilyDescriptions
    }
 
    static var ids: [Int] {
        var ids = [Int]()
        for d in ColorFamily.all {
            ids.append(d.id)
        }
        return ids
    }

}
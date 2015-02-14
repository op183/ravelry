//
//  UIColor.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/6/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

enum Color: UInt32 {
    
    case champagne = 0xFAF0D1
    case goldenrod = 0xFEDD6C
    case silver = 0xCCCCCC
    case neptuna = 0x83BDA7  //green : 131	189	167
    case gamboge = 0xEFA00F //orange : 239	160	15
    case paleLeaf = 0xC6D6BB //pale : 198	214	187
    case saffron = 0xF8D12B //gold : 248	209	43
    case pottersClay = 0x855F3A //brown : 133	95	58
    
    var uiColor: UIColor {
        var mask: UInt32 = 0xFF

        var blue = CGFloat(self.rawValue & mask)
        var green = CGFloat((self.rawValue & (mask << 8)) >> 8)
        var red = CGFloat((self.rawValue & (mask << 16)) >> 16)
        var abit = CGFloat(256.0)
        
        return UIColor(
            red: red / abit,
            green: green / abit,
            blue: blue / abit,
            alpha: 1.0
        )
    }
    
    var cgColor: CGColor {
        return self.uiColor.CGColor
    }
    
}


//
//  TextInput.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/3/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class TextInput: UITextField {
    override func textRectForBounds(bounds: CGRect) -> CGRect {

        var edgeInsets = CGRect(
            x: CGRectGetMinX(self.bounds),
            y: CGRectGetMinY(self.bounds) + 25,
            width: CGRectGetMaxX(self.bounds),
            height: 75
        )
        
        return super.textRectForBounds(edgeInsets)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {

        var edgeInsets = CGRect(
            x: CGRectGetMinX(self.bounds) + 10,
            y: CGRectGetMinY(self.bounds) + 10,
            width: CGRectGetMaxX(self.bounds) - 20,
            height: 55
        )

        return super.editingRectForBounds(edgeInsets)
    }
}

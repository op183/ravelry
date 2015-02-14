//
//  Needle.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

enum NeedleSize: Int {
    case US00000000 = 43
    case US000000 = 42
    case US00000 = 41
    case US0000 = 40
    case US000 = 39
    case US00 = 22
    case US0 = 19
    case US1 = 1
    case US1½ = 21
    case US2 = 2
    case US2½ = 20
    case US3 = 3
    case US4 = 4
    case US5 = 5
    case US6 = 6
    case US7 = 7
    case US8 = 8
    case US9 = 9
    case US10 = 10
    case US10½ = 11
    case Metric7 = 23
    case Metric7½ = 24
    case US11 = 12
    case US13 = 13
    case US15 = 14
    case US17 = 15
    case US19 = 16
    case US35 = 17
    case US50 = 18
 
    var id: Int {
        get {
            return self.rawValue
        }
    }

    var usSize: String? {
        get {
            switch self {
                case US00000000: return "00000000"
                case US000000: return "000000"
                case US00000: return "00000"
                case US0000: return "0000"
                case US000: return "000"
                case US00: return "00"
                case US0: return "0"
                case US1 : return "1"
                case US1½: return "1½"
                case US2 : return "2"
                case US2½: return "2½"
                case US3 : return "3"
                case US4 : return "4"
                case US5 : return "5"
                case US6 : return "6"
                case US7 : return "7"
                case US8 : return "8"
                case US9 : return "9"
                case US10 : return "10"
                case US10½: return "10½"
                case Metric7: return nil
                case Metric7½: return nil
                case US11 : return "11"
                case US13 : return "13"
                case US15 : return "15"
                case US17 : return "17"
                case US19 : return "19"
                case US35 : return "35"
                case US50 : return "50"
            }
            
        }
    }

    var metricSize: Float {
        get {
            switch self {
                case US00000000: return  0.5
                case US000000: return  0.75
                case US00000: return  1.0
                case US0000: return  1.25
                case US000: return  1.5
                case US00: return  1.75
                case US0: return  2.0
                case US1 : return  2.25
                case US1½: return  2.5
                case US2 : return  2.75
                case US2½: return  3.0
                case US3 : return  3.25
                case US4 : return  3.5
                case US5 : return  3.75
                case US6 : return  4.0
                case US7 : return  4.5
                case US8 : return  5.0
                case US9 : return  5.5
                case US10 : return  6.0
                case US10½: return  6.5
                case Metric7: return 7.0
                case Metric7½: return 7.5
                case US11 : return  8.0
                case US13 : return  9.0
                case US15 : return  10.0
                case US17 : return  12.75
                case US19 : return  15.0
                case US35 : return  19.0
                case US50 : return  25.0
            }
        }
    }

    var description: String {
        return String(
            format: "%@%.2f%@",
            (self.usSize != nil) ? "US\(self.usSize!)\n" : "",
            self.metricSize,
            "mm"
        )
    }
    
    static var descriptions: [String] {
        var strings = [String]()
        for d in NeedleSize.all {
            strings.append(d.description)
        }
        return strings
    }

    static var ids: [Int] {
        var ids = [Int]()
        for d in NeedleSize.all {
            ids.append(d.id)
        }
        return ids
    }

    static let all: [NeedleSize] = [
        .US00000000, .US000000, .US00000, .US0000, .US000, .US00, .US0, .US1, .US1½, .US2, .US2½, .US3, .US4, .US5, .US6, .US7, .US8, .US9, .US10, .US10½, .Metric7, .Metric7½, .US11, .US13, .US15, .US17, .US19, .US35, .US50
    ]

}


class Needle: BaseRavelryModel {

    var id: Int

    var hook: String?
    var size: NeedleSize?
    var craft: Craft?
    
    var name: String {
        get {
            if let desc = size?.description {
                return desc
            } else {
                return ""
            }
        }
    }
    
    init(id: Int) {
        self.id = id
        self.size = NeedleSize(rawValue: id)!
        super.init()
    }

}
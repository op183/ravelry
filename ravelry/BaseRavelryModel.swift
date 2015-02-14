//
//  BaseRavelryModel.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/20/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

enum Craft: Int {
    case Crochet = 1
    case Knitting = 2
    
    var id: Int {
        switch self {
        case .Crochet: return 1
        case .Knitting: return 2
        default: return 0
        }
    }
    
    var icon: UIImage {
        switch self {
            case .Crochet:
                return UIImage(named: "hook")!
            default:
                return UIImage(named: "needles")!
        }
    }
}

enum Status: Int {
    case InProgress = 1
    case Finished = 2
    case Hibernating = 3
    case Frogged = 4
    
    var name: String {
        get {
            switch self {
            case .Finished: return "Finished"
            case .Hibernating: return "Hibernating"
            case .Frogged: return "Frogged"
            default: return "In Progress"
            }
        }
    }
    
    var id: Int {
        get {
            switch self {
            case .Finished: return 2
            case .Hibernating: return 3
            case .Frogged: return 4
            default: return 1
            }
        }
    }
    
}

class BaseRavelryModel: NSObject {
    override init() {
       super.init()
    }
}

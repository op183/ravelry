//
//  Yarn.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

enum YarnWeight: Int {
    case Aran = 1
    case Bulky = 4
    case Fingering = 5
    case SuperBulky = 6
    case Lace = 7
    case Cobweb = 8
    case Thread = 9
    case Sport = 10
    case DK = 11
    case Worsted = 12
    case LightFingering = 13

    var id: Int {
        get {
            return self.rawValue
        }
    }

    var ply: Int? {
        get {
            switch self {
            case Aran: return 10
            case Bulky: return 12
            case Fingering: return 4
            case SuperBulky: return nil
            case Lace: return 2
            case Cobweb: return 1
            case Thread: return nil
            case Sport: return 5
            case DK: return 8
            case Worsted: return 10
            case LightFingering: return 3
            }
            
        }
    }

    var wpi: String? {
        get {
            switch self {
            case Aran: return "8"
            case Bulky: return "7"
            case Fingering: return "14"
            case SuperBulky: return "5-6"
            case Lace: return nil
            case Cobweb: return nil
            case Thread: return nil
            case Sport: return "12"
            case DK: return "11"
            case Worsted: return "9"
            case LightFingering: return nil
            }
            
        }
    }

    var name: String {
        get {
            switch self {
            case Aran: return "Aran"
            case Bulky: return "Bulky"
            case Fingering: return "Fingering"
            case SuperBulky: return "Super Bulky"
            case Lace: return "Lace"
            case Cobweb: return "Cobweb"
            case Thread: return "Thread"
            case Sport: return "Sport"
            case DK: return "DK"
            case Worsted: return "Worsted"
            case LightFingering: return "Light Fingering"
            }
            
        }
    }

    var description: String {
        get {
            var ply = (self.ply != nil) ? "\(self.ply!) ply" : ""
            var wpi = (self.wpi != nil) ? "(\(self.wpi!) wpi)" : ""
            return String(format: "%@%@",
                self.name,
                (self.ply != nil && self.wpi != nil) ? String(format: " %@ / %@", ply, wpi) : String(format: " %@%@", ply, wpi)
            )
        }
    }
    
    static var descriptions: [String] {
        var strings = [String]()
        for d in YarnWeight.all {
            strings.append(d.description)
        }
        return strings
    }
    
    static var ids: [Int] {
        var ids = [Int]()
        for d in YarnWeight.all {
            ids.append(d.id)
        }
        return ids
    }
    
    static let all: [YarnWeight] = [.Aran, .Bulky, .Fingering, .SuperBulky, .Lace, .Cobweb, .Thread, .Sport, .DK, .Worsted, .LightFingering]
    
}


class Yarn: BaseRavelryModel {
    
    var id: Int
    var name: String

    var company: String?
    
    var weightType: String?
    
    var wpi: String?
    var ply: String?
    
    var knitGauge: String?
    var minGauge: String?
    var crochetGauge: String?
    var maxGauge: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        super.init()
    }
    
}

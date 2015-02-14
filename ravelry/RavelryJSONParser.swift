//
//  RavelryJSONParser.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/24/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

class RavelryJSONParser<T>: JSONParser<T>, PhotoSetLoaderDelegate {

    var mDelegate: PhotoSetLoaderDelegate?
    var aDelegate: AsyncLoaderDelegate?

    var totalRecords: Int = 0
    var pageCount: Int = 0
    var pageSize: Int = 0
    var currentPage: Int = 0
    var lastPage: Int = 0
    
    override init() {
        super.init()
    }

    init(aDelegate: AsyncLoaderDelegate) {
        super.init()
        self.aDelegate = aDelegate
    }
    
    init(mDelegate: PhotoSetLoaderDelegate, aDelegate: AsyncLoaderDelegate) {
        super.init()
        self.aDelegate = aDelegate
        self.mDelegate = mDelegate
    }

    override func parse(json: NSDictionary) -> JSONParser<T> {
        if let paginator = json["paginator"] as? NSDictionary {
            totalRecords = paginator["results"] as Int
            pageCount = paginator["page_count"] as Int
            pageSize = paginator["page_size"] as Int
            currentPage = paginator["page"] as Int
            lastPage = paginator["last_page"] as Int
        }
        
        return self
    }
    
    func parsePatternResult(pattern: NSDictionary) -> Pattern? {
        var pattern_author: Author?
        var pattern_photo: PhotoSet?
        var pattern_sources = [PatternSource]()
        var name: String?
        
        name = pattern["name"] as String?
        
        if let author: NSDictionary = pattern["pattern_author"] as? NSDictionary {
            pattern_author = parseAuthor(author)
            
        } else {
            pattern_author = Author()
        }
        
        
        if let photo: NSDictionary = pattern["first_photo"] as? NSDictionary {
            pattern_photo = loadMipmap(photo, maxToLoad: 1)
        } else {
            checkProgress()
        }
        
        if let sources: NSDictionary = pattern["pattern_sources"] as? NSDictionary {
            
        }
        
        var newPattern = Pattern(
            id: pattern["id"] as Int,
            name: name!,
            photo: pattern_photo!,
            author: pattern_author!,
            sources: pattern_sources
        )
        return newPattern
    }
    
    func parseAuthor(author: NSDictionary) -> Author? {
        let id: Int = author["id"] as Int
        
        let patterns_count: Int = author["patterns_count"] as Int
        
        let permalink: NSURL? = NSURL(fileURLWithPath: author["permalink"] as String)
        
        if let users: NSArray = author["users"] as? NSArray {
            for user in users {
                /*
                let id: Int = user["id"] as Int
                let large_photo_url: String? = user["large_photo_url"] as String?
                let photo_url: String? = user["photo_url"] as String?
                let small_photo_url: String? = user["small_photo_url"] as String?
                let tiny_photo_url: String? = user["tiny_photo_url"] as String?
                let username: String = user["username"] as String
                */
            }
        }
        
        let favorites_count: Int = author["favorites_count"] as Int
        let name: String? = author["name"] as String?
        
        return Author(
            id: id,
            name: name,
            permalink: permalink,
            patterns_count: patterns_count,
            favorites_count: favorites_count
        )

    }
    
    func parseNeedleSize(needle: NSDictionary) -> Needle {
        let n = filterValues(needle)
        var ns = Needle(id: n["id"] as Int)
        //ns.hook = n["hook"] as? String
        //ns.USSize = n["us"] as? String
        //ns.USSteel = n["us_steel"] as? String
        //ns.metricSize = n["metric"] as? Float
        
        if let knitting = n["knitting"] as? Bool {
            ns.craft = .Knitting
        } else if let crochet = n["crochet"] as? Bool {
            ns.craft = .Crochet
        }

        return ns
    }
    
    func parseCategory(category: NSDictionary?) -> PatternCategory? {
        if let c = category {
            var pString = c["permalink"] as? String
            var permalink = NSURL(
                string: "http://www.ravelry.com/patterns/popular/\(pString)"
            )
            
            var name = c["name"] as? String
            var id = c["id"] as? Int
            var parent = parseCategory(c["parent"] as? NSDictionary)
            
            return PatternCategory(
                id: id,
                name: name,
                permalink: permalink,
                parent: parent
            )
        } else {
            return nil
        }
    }
    
    func parsePack(pack: NSDictionary) -> Pack {
        var id = 0

        if let pid = pack["id"] as? Int {
            id = pid
        }
        
        let p = Pack(id: id)

        /*
        if let yarn = pack["yarn"] as? NSDictionary {
            var y = filterValues(yarn)
            name = y["name"] as? String
            company = y["yarn_company_name"] as? String
        }
        */
        
        if let yarn: Yarn = parseYarn(
            id: pack["yarn_id"] as? Int,
            name: pack["yarn_name"] as? String,
            weight: pack["yarn_weight"] as? NSDictionary
            ) {
                p.yarn = yarn
        }
        
        if let skeins = pack["skeins"] as? Int {
            p.skeins = skeins
        }
        
        if let yards = pack["total_yards"] as? Float {
            p.yards = yards
        }
        
        if let grams = pack["total_grams"] as? Float {
            p.grams = grams
        }
        
        if let colorFamilyId = pack["color_family_id"] as? Int   {
            p.colorFamily = ColorFamily(rawValue: colorFamilyId)
        }
        
        if let colorway = pack["colorway"] as? String {
            p.colorway = colorway
        }

        if let dyeLot = pack["dye_lot"] as? String {
            p.dyeLot = dyeLot
        }
        
        if let notes = pack["notes"] as? String {
            p.notes = notes
        }
        
        return p
    }
    
    func parseYarn(#id: Int?, name: String?, weight: NSDictionary?) -> Yarn? {
        
        if id != nil && name != nil {
            var yarn = Yarn(id: id!, name: name!)
            
            if weight != nil {
                var y = filterValues(weight!)
                yarn.weightType = y["name"] as? String
                yarn.wpi = y["wpi"] as? String
                yarn.ply = y["ply"] as? String
                yarn.minGauge = y["minGauge"] as? String
                yarn.maxGauge = y["maxGauge"] as? String
                yarn.knitGauge = y["knitGauge"] as? String
                yarn.crochetGauge = y["crochetGauge"] as? String
            }
            return yarn
        }
        
        return nil
    }
    
    func parsePhotos(photos: NSArray?) -> [PhotoSet] {
        var mipmaps = [PhotoSet]()

        if photos != nil && photos!.count > 0 {
            for photo in photos! {
                mipmaps.append(loadMipmap(photo as? NSDictionary))
            }
        } else {
            mipmaps.append(PhotoSet(named: "missing-photo", delegate: self))
        }
        
        return mipmaps
    }
    
    
    func checkProgress(remaining: Int, _ total: Int) {
        
    }
    
    func checkProgress() {
        checkProgress(0, 0)
    }

    func loadMipmap(photo: NSDictionary?, maxToLoad: Int = 2) -> PhotoSet {
        var photoSet: PhotoSet?
        var photos = [PictureSize: String]()
        var selectedPhotos = 0

        if photo != nil {
            for size in PictureSize.all {
                if let sizedPhoto = photo![size.rawValue] as? String {
                    if PhotoSet.validatePhoto(sizedPhoto) {
                        photos[size] = sizedPhoto
                        ++selectedPhotos
                    }
                }
                
                if selectedPhotos >= maxToLoad {
                    break
                }
            }
            
            photoSet = PhotoSet(photos: photos, delegate: self)
            
            photoSet!.setOffset(
                x: photo!["x_offset"] as? Int,
                y: photo!["y_offset"] as? Int
            )
            
            photoSet!.setSortOrder(photo!["sort_order"] as? Int)
        } else {
            photoSet = PhotoSet(named: "missing-photo", delegate: self)
        }
        
        return photoSet!
    }
    
    func filterValues(values: NSDictionary) -> [String: AnyObject?] {
        var obj = [String: AnyObject?]()
        
        for (key, value) in values as NSDictionary {
            if value is String && value as String == "<null>" {
                obj[key as String] = nil as AnyObject?
            } else {
                obj[key as String] = value as AnyObject?
            }
        }
        return obj
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        //println("\t\t\(remaining) out of \(total) Photos loaded!")
        if mDelegate != nil {
            mDelegate!.imageHasLoaded(remaining, total)
        }
    }
}
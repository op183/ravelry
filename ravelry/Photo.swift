//
//  Photo.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/28/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

protocol PhotoDelegate {
    func photoHasLoaded(photo: Photo)
}

class Photo: BaseRavelryModel {

    var delegate: PhotoDelegate?
    var image: UIImage?
    var tag: String

    init(_ url: String, _ tag: String) {
        self.tag = tag
        super.init()

        Http.request(url, handler: {
            (
                response: NSURLResponse!,
                data: NSData!,
                error: NSError!
            ) -> Void in
            
            if data != nil {
                self.image = UIImage(data: data)
                self.delegate!.photoHasLoaded(self)
            } else {
                println("Image @ \(url) is Nil: \(error)")
            }

        })
    }
}
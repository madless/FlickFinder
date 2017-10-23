//
//  File.swift
//  FlickFinder
//
//  Created by dmikhov on 20.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import Foundation

class Photo {
    var name: String = "unnamed"
    var url: String?
    var id: String = ""
    
    init(_ id: String, _ name: String, _ url: String) {
        self.name = name
        self.url = url
        self.id = id
    }
}

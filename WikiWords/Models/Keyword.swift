//
//  Keyword.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import Foundation

struct Keyword: Codable {
    
    var title: String
    var summary: String?
    var imagePath: String?
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case summary
        case imagePath = "thumbnailImg"
        case imageData
    }
}

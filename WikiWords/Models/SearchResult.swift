//
//  SearchResult.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    
    var result: [Keyword]
    
    enum CodingKeys: String, CodingKey {
        
        case result = "geonames"
    }
}

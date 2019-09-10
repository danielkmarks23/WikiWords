//
//  ImageManager.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import Foundation

class ImageManager {
    
    var webService = WebService()
    
    func loadImage(imagePath: String, completion: @escaping ((Data) -> Void), catchError errorHandling: @escaping (Error) -> Void) {
        
        webService.loadData(url: imagePath, completion: completion, catchError: errorHandling)
    }
}

//
//  SearchManager.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import Foundation

class SearchManager {
    
    private var baseURL = "http://api.geonames.org/wikipediaSearchJSON"
    var webService = WebService()
    
    func searchKeywords(text: String, completion: @escaping (([Keyword]) -> Void), catchError errorHandling: @escaping (Error) -> Void) {
        
        let searchText = text.replacingOccurrences(of: " ", with: "%20")
        let url = baseURL + "?q=\(searchText)&maxRows=10&username=tingz"
        print(url)
        webService.load(url: url, completion: { (searchResult: SearchResult) in
            
            completion(searchResult.result)
        }, catchError: errorHandling)
    }
}

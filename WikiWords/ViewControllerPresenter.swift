//
//  ViewControllerPresenter.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import Foundation

protocol ViewControllerViewDelegate: NSObjectProtocol {
    func displayResults(list:[Keyword])
}

class ViewControllerPresenter {
    
    private let searchManager: SearchManager
    private let coreDataManager: CoreDataManager
    weak var delegate : ViewControllerViewDelegate?
    var selectedLocationIndex = 0
    
    init(searchManager: SearchManager, coreDataManager: CoreDataManager) {
        self.searchManager = searchManager
        self.coreDataManager = coreDataManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveImageData(_:)), name: NSNotification.Name(rawValue: "didReceiveImageData"), object: nil)
    }
    
    @objc private func onDidReceiveImageData(_ info: NSNotification) {
        
        if let first = info.userInfo?.first, let key = first.key as? String, let data = first.value as? Data {
            coreDataManager.update(title: key, imageData: data)
        }
    }
    
    func locationSegmentedControlChanged(selectedIndex: Int) {
        self.selectedLocationIndex = selectedIndex
    }
    
    func searchButtonPressed(text: String){
        
        if selectedLocationIndex == 0 {
            searchManager.searchKeywords(text: text, completion: { [weak self] results in
                
                print(results)
                
                self?.delegate?.displayResults(list: results)
                
                for item in results {
                    self?.coreDataManager.save(keyword: item, text: text)
                }
            }) { error in
                
                print(error)
            }
        } else if selectedLocationIndex == 1 {
            let results = coreDataManager.fetch(text: text)
            self.delegate?.displayResults(list: results)
        }
    }
}

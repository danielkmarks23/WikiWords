//
//  SearchResultTableViewCell.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import UIKit

public let searchResultTableViewCell = "SearchResultTableViewCell"

protocol TableViewCellViewModeling {
    
    var title: String { get set }
}

public struct SearchResultTableViewCellViewModel: TableViewCellViewModeling {
    
    var imagePath: String?
    var image: UIImage?
    var title: String
    var summary: String
    
    init(imagePath: String?, title: String, summary: String) {
        self.imagePath = imagePath
        self.title = title
        self.summary = summary
    }
}

public struct SearchResultImageTableViewCellViewModel: TableViewCellViewModeling {
    
    var image: UIImage?
    var title: String
    var summary: String
    
    init(imageData: Data?, title: String, summary: String) {
        
        if let imageData = imageData {
            self.image = UIImage(data:imageData)
        } else {
            self.image = UIImage(named: "placeholder")
        }
        
        self.title = title
        self.summary = summary
    }
}

class SearchResultTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    public func setup(with viewModel: SearchResultTableViewCellViewModel, index: Int) {
        titleLabel.text = viewModel.title
        summaryLabel.text = viewModel.summary
        loadImage(title: viewModel.title, index: index, path: viewModel.imagePath ?? "")
    }
    
    public func setup(with viewModel: SearchResultImageTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        summaryLabel.text = viewModel.summary
        thumbnailImageView.image = viewModel.image
    }
}

extension SearchResultTableViewCell {
    
    private func loadImage(title: String, index: Int, path: String) {
        
        if path == "" {
            thumbnailImageView.image = UIImage(named: "placeholder")
            return
        }
        
        ImageManager().loadImage(imagePath: path, completion: { data in
            
            if let image = UIImage(data: data) {
                
                DispatchQueue.main.async { [weak self] in
                    
                    if self?.tag == index {
                        self?.thumbnailImageView.image = image
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveImageData"), object: self, userInfo: [title: data])
                    }
                }
            }
        }) { error in
            print(error)
        }
    }
}

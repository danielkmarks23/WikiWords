//
//  ViewController.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ViewControllerViewDelegate {
    
    var list = [Keyword]()
    let presenter = ViewControllerPresenter(searchManager: SearchManager(), coreDataManager: CoreDataManager())

    @IBOutlet weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        presenter.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: searchResultTableViewCell)
        
        let bundle = Bundle(for: ViewController.self)
        let cellNib = UINib(nibName: searchResultTableViewCell, bundle: bundle)
        tableView.register(cellNib, forCellReuseIdentifier: searchResultTableViewCell)
    }
    
    @IBAction func locationSegmentedControlChanged(_ sender: Any) {
        
        presenter.locationSegmentedControlChanged(selectedIndex: locationSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        searchTextField.resignFirstResponder()
        presenter.searchButtonPressed(text: searchTextField.text ?? "")
    }
    
    func displayResults(list: [Keyword]) {
        
        self.list = list
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultTableViewCell, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        cell.thumbnailImageView.image = nil
        
        let item = list[indexPath.row]
        
        if presenter.selectedLocationIndex == 0 {
            let viewModel = SearchResultTableViewCellViewModel(imagePath: item.imagePath, title: item.title, summary: item.summary ?? "")
            
            cell.tag = indexPath.row
            cell.setup(with: viewModel, index: indexPath.row)
            
            return cell
        } else if presenter.selectedLocationIndex == 1 {
            let viewModel = SearchResultImageTableViewCellViewModel(imageData: item.imageData, title: item.title, summary: item.summary ?? "")
            cell.setup(with: viewModel)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

//
//  CategoriesTableViewController.swift
//  ProductYmlViewer
//
//  Created by Сергей Бушкевич on 1.08.21.
//

import UIKit

class CategoriesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        return table
    }()
    
    private var parsedCategories: [Category]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        //fetchTopStories()
        
        fetchData()
    }
    
    private func fetchData(){
        let categoriesParser = YmlFeedParser()
        categoriesParser.parseFeed(url: YmlFeedParser.Constants.feedURL) { result in
            self.parsedCategories = result
            
            //print(self.parsedCategories)

            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = parsedCategories else {
            return 0
        }
        
        return categories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(viewModels[indexPath.row])
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoriesTableViewCell.identifier,
            for: indexPath
        ) as? CategoriesTableViewCell else{
            fatalError()
        }
        
        
        if let cat = parsedCategories?[indexPath.row]{
            cell.categoryTitleLabel.text = cat.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

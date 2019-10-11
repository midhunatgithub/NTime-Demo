//
//  HomeViewController.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/29/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HomeSceneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NY Times"
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.bounds.width, height: 70.0)))
        tableView.estimatedRowHeight = 267.0
        viewModel.delegate = self
        viewModel.timePeriodSegmentDidSelected(atIndex: 0)
        
    }
    @IBAction func timePeriodSegmentDidChanged(_ sender: UISegmentedControl) {
        viewModel.timePeriodSegmentDidSelected(atIndex: sender.selectedSegmentIndex)
    }
    @IBAction func newsTypeSegmentDidChanged(_ sender: UISegmentedControl) {
    }
    
}
extension HomeViewController {
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        viewModel.configure(cell: cell, atIndexPath: indexPath)
        return cell
    }

}
extension HomeViewController: HomeSceneViewModelDelegate {
    func tableViewReloadingNeeded() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

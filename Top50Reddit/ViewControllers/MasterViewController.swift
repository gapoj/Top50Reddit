//
//  MasterViewController.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    private var viewModel = RedditViewModel()
    var detailViewController: DetailViewController? = nil
    
    let network = NetworkLayer()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        activityindicator.startAnimating()
        viewModel.delegate = self
        
        getData()
        
    }
    
    @objc func getData(){
        
        activityindicator.startAnimating()
        viewModel.reset()
        viewModel.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed, let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func dismissAllAction(_ sender: Any) {
        let indexSet = IndexSet(arrayLiteral: 0)
        viewModel.reset()
        tableView.reloadSections(indexSet, with: .bottom)
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = viewModel.post(at:indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                object.visited = true
                if let cell = tableView.cellForRow(at: indexPath) as? PostCell{
                    cell.readedSignView.isHidden = true
                }
            }
        }
    }
}
extension MasterViewController: UITableViewDataSource{
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostCell{
            
            if isLoadingCell(for: indexPath) {
                cell.configure(withPost: .none)
            } else {
                let post = viewModel.post(at: indexPath.row)
                cell.configure(withPost: post)
            }
            cell.delegate = self
            //adding white disclousure indicator
            let imgView = UIImageView(frame: CGRect(x: 0, y: 11, width: 18, height: 18))
            imgView.contentMode = .scaleAspectFit
            imgView.image = #imageLiteral(resourceName: "chevron-right")
            cell.accessoryView = imgView
            return cell
        }
        return UITableViewCell()
    }
    
}
extension MasterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getData()
        }
    }
}
private extension MasterViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
extension MasterViewController: PostCellDelegate {
    func dismiss(cell: PostCell) {
        if let index = tableView.indexPath(for: cell){
            viewModel.removePost(at: index.row)
            viewModel.deleted += 1
            tableView.deleteRows(at: [index], with: .left)
            
            
        }
    }
}
//  MARK:- UIViewControllerRestoration
extension MasterViewController{
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        // preserve all user model object.
        
        coder.encode(self.viewModel.posts, forKey: "arrPost")
        
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let arr = coder.decodeObject(forKey: "arrPost") as? [RedditPost]{
            
            self.viewModel.posts = arr
            
        }
    }
    override func applicationFinishedRestoringState() {
        print("MasterViewController finished restoring")
        self.tableView.reloadData()
    }
}

extension MasterViewController: RedditViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // first load
        refreshControl.endRefreshing()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityindicator.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        print(newIndexPathsToReload)
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        activityindicator.stopAnimating()
        
        let ac = UIAlertController(title: "", message: reason, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}


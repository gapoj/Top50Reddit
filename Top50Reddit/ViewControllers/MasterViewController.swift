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
    
    static let url = "https://www.reddit.com/top.json?limit=50"
    var detailViewController: DetailViewController? = nil
    let network = NetworkLayer()
    var posts = [RedditPost]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getData()
        
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
        posts.removeAll()
        tableView.reloadSections(indexSet, with: .bottom)
    }
    
    // MARK: - Network
    
    @objc func getData() {
        activityindicator.startAnimating()
        network.get(urlString: MasterViewController.url,  successHandler: { [weak self](res:ListingResponse)  in
            guard let strongSelf = self else{return}
            print(res.posts)
            strongSelf.posts = res.posts
            DispatchQueue.main.async {
                strongSelf.activityindicator.stopAnimating()
                strongSelf.tableView.reloadData()
                strongSelf.refreshControl.endRefreshing()
            }
        }) {  [weak self](err) in
            guard let strongSelf = self else{return}
            strongSelf.activityindicator.stopAnimating()
            strongSelf.refreshControl.endRefreshing()
            let alertController = UIAlertController(title: "", message: err, preferredStyle: .alert)
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = posts[indexPath.row]
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostCell{
            let post = posts[indexPath.row]
            cell.configure(withPost: post)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension MasterViewController: PostCellDelegate {
    func dismiss(cell: PostCell) {
        if let index = tableView.indexPath(for: cell){
            posts.remove(at: index.row)
            tableView.deleteRows(at: [index], with: .left)
            
        }
    }
}

//
//  RedditViewModel.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/20/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

protocol RedditViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class RedditViewModel {
    private let url = "https://www.reddit.com/top.json?limit=10"
    // MARK: - Network
    private let maxPosts = 50
    var deleted = 0
    private let network = NetworkLayer()
    var posts = [RedditPost]()
    var delegate:RedditViewModelDelegate?
    //private var total = 0
    private var isFetchInProgress = false
    private var after:String?
    private var firstPage = true
    func post(at index: Int) -> RedditPost {
        return posts[index]
    }
    func removePost(at index: Int) {
      posts.remove(at: index)
    }
    var currentCount: Int {
        return posts.count
    }
    var total: Int {
        return posts.isEmpty ? 0 : (maxPosts - deleted) ///if we have not post not showing the pagination
    }
    func reset(){
        deleted = 0
        firstPage = true
        after = nil
        posts.removeAll()
    }
    func getData() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
       var completeurl = url
        if !firstPage, let afterNotNil = after {
            completeurl += "&after=\(afterNotNil)"
        }
        network.get(urlString: completeurl,  successHandler: { [weak self](res:ListingResponse)  in
            guard let strongSelf = self else{return}
            strongSelf.after = res.data.after
            strongSelf.isFetchInProgress = false
            DispatchQueue.main.async {
                strongSelf.posts.append(contentsOf: res.posts)
                if strongSelf.firstPage{
                    strongSelf.firstPage = false
                    strongSelf.delegate?.onFetchCompleted(with: .none)
                }else{
                    let indexPathsToReload = strongSelf.calculateIndexPathsToReload(from: res.posts)
                    strongSelf.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
            }
        }) {  [weak self](err) in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async {
                strongSelf.isFetchInProgress = false
                strongSelf.delegate?.onFetchFailed(with: err)
            }
        }
    }
    private func calculateIndexPathsToReload(from newPosts: [RedditPost]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

//
//  HeadlinesChildViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/28/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import Foundation
import SwiftSpinner

class HeadlinesChildViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    @IBOutlet var NewsTable: UITableView!
    
    var articles = [Article]()
    var refreshControl = UIRefreshControl()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItem") as! ArticleTableViewCell
        do {
            let article = articles[indexPath.section]
            cell.setArticle(article: article)
        }
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.selectedBackgroundView?.layer.cornerRadius = 11
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SwiftSpinner.hide()
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ArticleDetailViewController,
            let index = NewsTable.indexPathForSelectedRow?.section
            else {
                return
        }
        detailViewController.article = articles[index]
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.section
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(index: index)
        })
    }
    
    func makeContextMenu(index: Int) -> UIMenu {
        let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
            let tweetText = "Check out this Article!"
            let tweetUrl = self.articles[index].url
            let tweetHashtags = "CSCI_571_NewsApp"

            let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtags)"

            // encode a space to %20 for example
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

            // cast to an url
            let url = URL(string: escapedShareString)

            // open in safari
            UIApplication.shared.open(url!)
        }
        
        // 4
        let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                // Just showing some alert
            print("bookmark")
        }
        // 5
        return UIMenu(title: "menu", image: nil, children: [share, bookmark])
    }
    
    
    
    var section: String = ""

    override func viewDidLoad() {
        SwiftSpinner.show("Loading \(section) Headlines..")
        super.viewDidLoad()
        NewsTable.dataSource = self
        NewsTable.delegate = self
        fetchArticles()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        NewsTable.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
         return IndicatorInfo(title: "\(section)")
    }
    
    @objc func didPullToRefresh() {
        fetchArticles()
        self.refreshControl.endRefreshing()
    }
    
    func fetchArticles() {
            self.articles.removeAll()
            self.NewsTable.reloadData()
            AF.request("https://my-first-gcp-project-271002.appspot.com/\(section)").responseJSON {
                response in switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for item in json {
                        let info = item.1
                        let title = info["title"].string!
                        let image = info["image"].string!
                        let time = info["diff"].string!
                        let section = info["section"].string!
                        let id = info["id"].string!
                        let url = info["url"].string!
                        let article = Article(image: image, title: title, time: time, section: section, id: id, url: url)
                        self.articles.append(article)
                    }
                    self.NewsTable.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    //        DispatchQueue.main.async {
    //            SwiftSpinner.hide()
    //        }
        }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

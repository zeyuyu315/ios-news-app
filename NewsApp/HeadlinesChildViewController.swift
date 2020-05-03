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
        cell.headlinelink = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NewsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ArticleDetailViewController,
            let index = NewsTable.indexPathForSelectedRow?.section
            else {
                return
        }
        detailViewController.article = articles[index]
    }
    
    var section: String = ""

    override func viewDidLoad() {
        SwiftSpinner.show("Loading \(section) Headlines..")
        super.viewDidLoad()
        NewsTable.dataSource = self
        NewsTable.delegate = self
        NewsTable.separatorColor = UIColor.clear
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
        var tempArticles : [Article] = []
        AF.request("https://my-first-gcp-project-271002.appspot.com/\(section)").responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json {
                    let info = item.1
                    let title = info["title"].string!
                    let image = info["image"].string!
                    let time = info["time"].string!
                    let diff = info["diff"].string!
                    let section = info["section"].string!
                    let id = info["id"].string!
                    let url = info["url"].string!
                    let article = Article(image: image, title: title, time: time, section: section, id: id, url: url, diff: diff)
                    tempArticles.append(article)
                }
                DispatchQueue.main.async{
                    self.articles = tempArticles
                    self.NewsTable.reloadData()
                    SwiftSpinner.hide()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func favClick() {
        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
    }
    
    func unFavClick() {
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
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

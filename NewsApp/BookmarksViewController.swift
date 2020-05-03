//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/30/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var NewsCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.articles.count == 0) {
            NewsCollection.setEmptyMessage("No bookmarks added.")
        } else {
            NewsCollection.restore()
        }

        return self.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkItem", for: indexPath) as! ArticleCollectionViewCell
        do {
            let article = articles[indexPath.item]
            cell.setArticle(article: article)
        }
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.selectedBackgroundView?.layer.cornerRadius = 11
        cell.bookmarklink = self
        return cell
    }
    
    var articles = [Article]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsCollection.dataSource = self
        NewsCollection.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveArticle()
        NewsCollection.reloadData()
    }
    
    func saveArticle() {
        var articlesTemp = [Article]()
        let keys = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
        for key in keys {
            if let savedArticle = defaults.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let loadedArticle = try? decoder.decode(Article.self, from: savedArticle) {
                    articlesTemp.insert(loadedArticle, at: 0)
                }
            }
        }
        articles = articlesTemp
//        for art in articles {
//            print(art.title)
//        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let detailViewController = segue.destination as? ArticleDetailViewController,
//            let index = NewsTable.indexPathForSelectedRow?.section
//            else {
//                return
//        }
//        detailViewController.article = articles[index]
//    }
    
    func favClick() {
        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
        saveArticle()
        NewsCollection.reloadData()
    }
    
    func unFavClick() {
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
        saveArticle()
        NewsCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ArticleDetailViewController,
            let index = NewsCollection.indexPathsForSelectedItems?.first
            else {
                return
        }
        detailViewController.article = articles[index.item]
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

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}


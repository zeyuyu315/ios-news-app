//
//  ArticleCollectionViewCell.swift
//  NewsApp
//
//  Created by Zeyu Yu on 5/2/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    let defaults = UserDefaults.standard
    var id = ""
    var article: Article?
    var bookmarklink: BookmarksViewController?
    
    @IBOutlet var favIcon: UIButton!
    @IBOutlet var articleImage: URLimageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var section: UILabel!
    
    @IBAction func ClickFav(_ sender: Any) {
        let saved = defaults.object(forKey: id) != nil
        if saved {
            favIcon.setImage(UIImage(systemName: "bookmark"), for: [])
            defaults.removeObject(forKey: id)
            var savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
            if let index = savedArray.firstIndex(of: id) {
                savedArray.remove(at: index)
            }
            defaults.set(savedArray, forKey: "savedArray")
            bookmarklink?.unFavClick()
        } else {
            favIcon.setImage(UIImage(systemName: "bookmark.fill"), for: [])
            if let encoded = try? JSONEncoder().encode(article) {
                UserDefaults.standard.set(encoded, forKey: id)
            }
            let array = defaults.array(forKey: "savedArray")
            if array == nil {
                defaults.set([], forKey: "savedArray")
            }
            var savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
            savedArray.append(id)
            defaults.set(savedArray, forKey: "savedArray")
            bookmarklink?.favClick()
        }
    }
    
    func setArticle(article: Article) {
        self.article = article
        articleImage.loadURL(url: URL(string: article.image)!)
        articleImage.layer.cornerRadius = 10
        title.text = article.title
        time.text = article.time
        section.text = "| " + article.section
        id = article.id
        let saved = defaults.object(forKey: id) != nil
        if saved {
            favIcon.setImage(UIImage(systemName: "bookmark.fill"), for: [])
        } else {
            favIcon.setImage(UIImage(systemName: "bookmark"), for: [])
        }
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
}

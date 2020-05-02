//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import Toast_Swift

class ArticleTableViewCell: UITableViewCell {
    
    let defaults = UserDefaults.standard
    @IBOutlet var articleImage: URLimageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var section: UILabel!
    var id = ""
    var url = ""
    @IBOutlet var favIcon: UIButton!
    var article: Article?
    
    var homelink: HomeViewController?
    var headlinelink: HeadlinesChildViewController?
    
    @IBAction func ClickFav(_ sender: Any) {
        let saved = defaults.object(forKey: id) != nil
        if saved {
            favIcon.setImage(UIImage(systemName: "bookmark"), for: [])
            defaults.removeObject(forKey: id)
            homelink?.unFavClick()
            headlinelink?.unFavClick()
        } else {
            favIcon.setImage(UIImage(systemName: "bookmark.fill"), for: [])
            if let encoded = try? JSONEncoder().encode(article) {
                UserDefaults.standard.set(encoded, forKey: id)
            }
            homelink?.favClick()
            headlinelink?.favClick()
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
        url = article.url
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    
}

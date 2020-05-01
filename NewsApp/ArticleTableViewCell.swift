//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    let defaults = UserDefaults.standard
    @IBOutlet var articleImage: URLimageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var section: UILabel!
    var id = ""
    var url = ""
    @IBOutlet var favIcon: UIButton!
    
    @IBAction func ClickFav(_ sender: Any) {
        let saved = defaults.object(forKey: id) != nil
        debugPrint(saved)
        if saved {
            favIcon.setImage(UIImage(systemName: "bookmark"), for: [])
            defaults.removeObject(forKey: id)
        } else {
            favIcon.setImage(UIImage(systemName: "bookmark.fill"), for: [])
            let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: , requiringSecureCoding: false)
            guard let data = encodedData else {
                print("Im here")
                return
            }
            self.defaults.set(data, forKey: self.id)
            debugPrint(defaults.object(forKey: id) != nil)
        }
    }
    
    func setArticle(article: Article) {
        articleImage.loadURL(url: URL(string: article.image)!)
        articleImage.layer.cornerRadius = 10
        title.text = article.title
        time.text = article.time
        section.text = "| " + article.section
        id = article.id
        url = article.url
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    
}

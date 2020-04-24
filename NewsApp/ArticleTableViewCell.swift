//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var section: UILabel!
    
    func setArticle(article: Article) {
        articleImage.load(url: URL(string: article.image!)!)
        articleImage.layer.cornerRadius = 10
        title.text = article.title
        time.text = article.time
        section.text = "| " + article.section!
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

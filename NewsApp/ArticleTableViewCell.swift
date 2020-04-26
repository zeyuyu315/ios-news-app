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
    var id = ""
    
    func setArticle(article: Article) {
        articleImage.load(url: URL(string: article.image)!)
        articleImage.layer.cornerRadius = 10
        title.text = article.title
        time.text = article.time
        section.text = "| " + article.section
        id = article.id
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if url == URL(string: "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png")  {
                print("123")
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "default-guardian")
                }
            } else {
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
}

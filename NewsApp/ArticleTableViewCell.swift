//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import Toast_Swift

class ArticleTableViewCell: UITableViewCell, UIContextMenuInteractionDelegate {
    
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
    var resultlink: ResultViewController?
    
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
            homelink?.unFavClick()
            headlinelink?.unFavClick()
            resultlink?.unFavClick()
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
            homelink?.favClick()
            headlinelink?.favClick()
            resultlink?.favClick()
        }
    }
    
    func setArticle(article: Article) {
        self.article = article
        articleImage.loadURL(url: URL(string: article.image)!)
        articleImage.layer.cornerRadius = 10
        title.text = article.title
        time.text = article.diff
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
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in

            return self.makeContextMenu()
        })
    }
    
        func makeContextMenu() -> UIMenu {
            let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                let tweetText = "Check out this Article!"
                let tweetUrl = self.url
                let tweetHashtags = "CSCI_571_NewsApp"
    
                let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtags)"
    
                // encode a space to %20 for example
                let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
                // cast to an url
                let url = URL(string: escapedShareString)
    
                // open in safari
                UIApplication.shared.open(url!)
            }
    
            let saved = defaults.object(forKey: id) != nil
            var bookmark : UIAction!
            if saved {
                bookmark = UIAction(title: "Unbookmark", image: UIImage(systemName: "bookmark.fill")) { action in
                    self.defaults.removeObject(forKey: self.id)
                    var savedArray = self.defaults.object(forKey: "savedArray") as? [String] ?? [String]()
                    if let index = savedArray.firstIndex(of: self.id) {
                        savedArray.remove(at: index)
                    }
                    self.defaults.set(savedArray, forKey: "savedArray")
                    self.favIcon.setImage(UIImage(systemName: "bookmark"), for: [])
                    self.homelink?.unFavClick()
                    self.headlinelink?.unFavClick()
                    self.resultlink?.unFavClick()
                }
            } else {
                bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                        // Just showing some alert
                    if let encoded = try? JSONEncoder().encode(self.article) {
                        self.defaults.set(encoded, forKey: self.id)
                    }
                    let array = self.defaults.array(forKey: "savedArray")
                    if array == nil {
                        self.defaults.set([], forKey: "savedArray")
                    }
                    var savedArray = self.defaults.object(forKey: "savedArray") as? [String] ?? [String]()
                    savedArray.append(self.id)
                    self.defaults.set(savedArray, forKey: "savedArray")
                    self.favIcon.setImage(UIImage(systemName: "bookmark.fill"), for: [])
                    self.homelink?.favClick()
                    self.headlinelink?.favClick()
                    self.resultlink?.favClick()
                }
            }
            return UIMenu(title: "menu", image: nil, children: [share, bookmark])
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    
}

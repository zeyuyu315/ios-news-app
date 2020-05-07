//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/26/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet var image: URLimageView!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var section: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var detailDescription: UILabel!
    @IBOutlet var favIcon: UIBarButtonItem!
    let defaults = UserDefaults.standard
    
    @IBAction func clickFav(_ sender: UIBarButtonItem) {
        let id = article!.id
        let saved = defaults.object(forKey: id) != nil
        if saved {
            favIcon.image = UIImage(systemName: "bookmark")
            defaults.removeObject(forKey: id)
            var savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
            if let index = savedArray.firstIndex(of: id) {
                savedArray.remove(at: index)
            }
            defaults.set(savedArray, forKey: "savedArray")
            self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
        } else {
            favIcon.image = UIImage(systemName: "bookmark.fill")
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
            self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let id = article!.id
        let saved = defaults.object(forKey: id) != nil
        if saved {
            favIcon.image = UIImage(systemName: "bookmark.fill")
        } else {
            favIcon.image = UIImage(systemName: "bookmark")
        }
    }
    
    
    @IBAction func ViewButton(_ sender: Any) {
        let redirectURL = URL(string: self.link)
        UIApplication.shared.open(redirectURL!)
    }
    @IBAction func TwitterButton(_ sender: Any) {
        let tweetText = "Check out this Article!"
        let tweetUrl = self.link
        let tweetHashtags = "CSCI_571_NewsApp"

        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtags)"

        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        // cast to an url
        let url = URL(string: escapedShareString)

        // open in safari
        UIApplication.shared.open(url!)
    }
    
    var article: Article?
    var link: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Detailed Page..")
        navigationItem.title = article?.title
        self.requestDetail(article!.id)
        // Do any additional setup after loading the view.
    }
    
    func requestDetail(_ id:String) {
        let url = "https://my-first-gcp-project-271002.appspot.com/IOSarticle/" + id
        AF.request(url).responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                let imageURL = json["image"].string!
                DispatchQueue.main.async {
                    if imageURL == "" {
                        self.image.image = UIImage(named: "default-guardian")
                    } else {
                        let data = try? Data(contentsOf: URL(string: imageURL)!)
                            self.image.image = UIImage(data: data!)
                    }
                    self.section.text = json["section"].string
                    self.time.text = json["date"].string
                    self.detailTitle.text = json["title"].string
                    self.link = json["url"].string!
                    var description = json["description"].string!
                    let regex = try! NSRegularExpression(pattern: "<iframe.*iframe>", options: NSRegularExpression.Options.caseInsensitive)
                    let range = NSMakeRange(0, description.count)
                    description = regex.stringByReplacingMatches(in: description, options: [], range: range, withTemplate: "")
                    let data = Data(description.utf8)
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        self.detailDescription.attributedText = attributedString
                        self.detailDescription.font = UIFont.systemFont(ofSize: 17)
                    }
                    SwiftSpinner.hide()
                }
            case .failure(let error):
                print(error)
            }
        }
        
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

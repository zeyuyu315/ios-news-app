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

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet var image: URLimageView!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var section: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var detailDescription: UILabel!
    
    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Detailed Page..")
        navigationItem.title = article?.title
        self.requestDetail(article!.id)
        // Do any additional setup after loading the view.
    }
    
    func requestDetail(_ id:String) {
        debugPrint(id)
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
                    let data = Data(json["description"].string!.utf8)
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        self.detailDescription.attributedText = attributedString
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

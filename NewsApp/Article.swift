//
//  Article.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import Foundation
import UIKit

class Article: NSObject, NSCoding {
    var image: String
    var title: String
    var time: String
    var section: String
    var id: String
    var url: String
    
    init(image: String, title: String, time: String, section: String, id: String, url:String) {
        self.image = image
        self.title = title
        self.time = time
        self.section = section
        self.id = id
        self.url = url
    }
    
    required convenience init?(coder: NSCoder) {
        let image = coder.decodeObject(forKey: "image") as! String
        let title = coder.decodeObject(forKey: "title") as! String
        let time = coder.decodeObject(forKey: "time") as! String
        let section = coder.decodeObject(forKey: "section") as! String
        let id = coder.decodeObject(forKey: "id") as! String
        let url = coder.decodeObject(forKey: "url") as! String
        self.init(image: image, title: title, time: time, section: section, id: id, url:url)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(title, forKey: "title")
        coder.encode(time, forKey: "time")
        coder.encode(section, forKey: "section")
        coder.encode(id, forKey: "id")
        coder.encode(url, forKey: "url")
    }
}

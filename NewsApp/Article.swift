//
//  Article.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/23/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import Foundation
import UIKit

class Article {
    var image: String
    var title: String
    var time: String
    var section: String
    var id: String
    
    init(image: String, title: String, time: String, section: String, id: String) {
        self.image = image
        self.title = title
        self.time = time
        self.section = section
        self.id = id
    }
}

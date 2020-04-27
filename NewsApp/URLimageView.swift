//
//  URLimageView.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/26/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class URLimageView: UIImageView {
    
    func loadURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if url == URL(string: "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png")  {
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

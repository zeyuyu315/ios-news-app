//
//  TrendingViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/28/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var textField: UITextField!
    var search = "Coronavirus"
    @IBOutlet var myChart: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChart()
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.search = textField.text!
        createChart()
        return true
    }
    
    func createChart() {
        
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


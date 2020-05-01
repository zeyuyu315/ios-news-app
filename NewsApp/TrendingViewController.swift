//
//  TrendingViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/28/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class TrendingViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var textField: UITextField!
    var search = "Coronavirus"
    @IBOutlet var lineCharView: LineChartView!
    
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
        let url = "https://my-first-gcp-project-271002.appspot.com/IOStrend/query/" + search
        AF.request(url).responseJSON {
            response in switch response.result {
            case .success(let value):
                let numbers = JSON(value)
                var lineChartEntry = [ChartDataEntry]()
                for i in 0..<numbers.count {
                    let value = ChartDataEntry(x: Double(i), y: numbers[i].double!)
                    lineChartEntry.append(value)
                }
                let line = LineChartDataSet(entries:lineChartEntry, label: "Trending Chart for " + self.search)
                line.colors = [UIColor.systemBlue]
                line.circleColors = [UIColor.systemBlue]
                line.circleHoleRadius = 0
                line.circleRadius = 5
                let data = LineChartData(dataSet: line)
                self.lineCharView.data = data
            case .failure(let error):
                print(error)
            }
        }
        debugPrint()
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


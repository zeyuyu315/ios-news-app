//
//  AutoSuggestTableViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 5/2/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class AutoSuggestTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var search = ""
    var originalDataSource : [String] = []
    var dataSource : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        //Do Stuff with the string
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getData() {
        self.articles.removeAll()
        AF.request("https://my-first-gcp-project-271002.appspot.com/\(section)").responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json {
                    let info = item.1
                    let title = info["title"].string!
                    let image = info["image"].string!
                    let time = info["time"].string!
                    let diff = info["diff"].string!
                    let section = info["section"].string!
                    let id = info["id"].string!
                    let url = info["url"].string!
                    let article = Article(image: image, title: title, time: time, section: section, id: id, url: url, diff: diff)
                    self.articles.append(article)
                }
                DispatchQueue.main.async{
                   self.NewsTable.reloadData()
                   SwiftSpinner.hide()
                }
            case .failure(let error):
                print(error)
            }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

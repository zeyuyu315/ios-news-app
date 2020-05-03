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
        search = searchText
        //Do Stuff with the string
        if search != "" {
            getData()
        }
    }
    
    func getData() {
        var newDataSource: [String] = []
        let headers: HTTPHeaders =  [
            "Ocp-Apim-Subscription-Key": "df49b0cf1d55421891688ea81f84f0b3"
        ]

        AF.request("https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=\(search)", headers: headers).responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                let searchSuggestions = json["suggestionGroups"][0]["searchSuggestions"]
                for suggestion in searchSuggestions {
                    let suggestItem = suggestion.1
                    newDataSource.append( suggestItem["displayText"].string!)
                }
                self.dataSource = newDataSource
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = dataSource[indexPath.row]
        let dic = ["search": searchText]
        NotificationCenter.default.post(name: Notification.Name("searchClicked"), object: nil, userInfo: dic)
    }
    
    

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

//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/22/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire
import Foundation
import SwiftSpinner

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet var WeatherImage: UIImageView!
    @IBOutlet var city: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var NewsTable: UITableView!
    
    var articles = [Article]()
    var refreshControl = UIRefreshControl()
    
    var locationManager: CLLocationManager?
    let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]

    func longStateName(_ stateCode:String) -> String {
        let dic = NSDictionary(objects: fullStateNames, forKeys:stateCodes as [NSCopying])
        return dic.object(forKey:stateCode) as? String ?? stateCode
    }
    
    override func viewDidLoad() {
        SwiftSpinner.show("Loading Home Page..")
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Enter keyword.."
        navigationItem.searchController = search
        navigationController?.navigationBar.sizeToFit()
        NewsTable.dataSource = self
        NewsTable.delegate = self
        fetchArticles()
        WeatherImage.layer.cornerRadius = 10
        WeatherImage.clipsToBounds = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.requestWhenInUseAuthorization()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        NewsTable.addSubview(refreshControl)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    
    @objc func didPullToRefresh() {
        fetchArticles()
        self.refreshControl.endRefreshing()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        manager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(lastLocation,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                guard let placeMark = placemarks?.first else { return }
                let cityName = placeMark.subAdministrativeArea!
                self.city.text = cityName
                let stateName = placeMark.administrativeArea!
                self.state.text = self.longStateName(stateName)
                self.requestWeather(cityName)
            }
            else {
             // An error occurred during geocoding.
                print("error occurred during geocoding")
            }
        })
    }
    
    func requestWeather(_ cityName:String) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let parameters = ["q": cityName, "units": "metric", "appid": "c84d264f547001d6eb186f2c6ee8024f"]
        AF.request(url, parameters: parameters).responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                var temp = String(Int(round(json["main"]["temp"].doubleValue)))
                temp += "°C"
                self.temperature.text = temp
                let weather = json["weather"][0]["main"].string
                self.weather.text = weather
                var weatherImage = ""
                switch weather {
                case "Clouds":
                    weatherImage = "cloudy_weather"
                case "Clear":
                    weatherImage = "clear_weather"
                case "Snow":
                    weatherImage = "snowy_weather"
                case "Rain":
                    weatherImage = "rainy_weather"
                case "Thunderstorm":
                    weatherImage = "thunder_weather"
                default:
                    weatherImage = "sunny_weather"
                }
                self.WeatherImage.image = UIImage(named: weatherImage)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SwiftSpinner.hide()
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItem") as! ArticleTableViewCell
        do {
            let article = articles[indexPath.section]
            cell.setArticle(article: article)
        }
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.selectedBackgroundView?.layer.cornerRadius = 11
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.section
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(index: index)
        })
    }
    
    func makeContextMenu(index: Int) -> UIMenu {
        let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
            let tweetText = "Check out this Article!"
            let tweetUrl = self.articles[index].url
            let tweetHashtags = "CSCI_571_NewsApp"

            let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)&hashtags=\(tweetHashtags)"

            // encode a space to %20 for example
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

            // cast to an url
            let url = URL(string: escapedShareString)

            // open in safari
            UIApplication.shared.open(url!)
        }
        
        // 4
        let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                // Just showing some alert
            print("bookmark")
        }
        // 5
        return UIMenu(title: "menu", image: nil, children: [share, bookmark])
    }    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ArticleDetailViewController,
            let index = NewsTable.indexPathForSelectedRow?.section
            else {
                return
        }
        detailViewController.article = articles[index]
    }
    
    func fetchArticles() {
        self.articles.removeAll()
        self.NewsTable.reloadData()
        AF.request("https://my-first-gcp-project-271002.appspot.com/IOShomepage").responseJSON {
            response in switch response.result {
            case .success(let value):
                let json = JSON(value)
                for item in json {
                    let info = item.1
                    let title = info["title"].string!
                    let image = info["image"].string!
                    let time = info["diff"].string!
                    let section = info["section"].string!
                    let id = info["id"].string!
                    let url = info["url"].string!
                    let article = Article(image: image, title: title, time: time, section: section, id: id, url: url)
                    self.articles.append(article)
                }
                self.NewsTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
//        DispatchQueue.main.async {
//            SwiftSpinner.hide()
//        }
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

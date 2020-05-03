//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by Zeyu Yu on 4/27/20.
//  Copyright © 2020 Zeyu Yu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeadlinesViewController: ButtonBarPagerTabStripViewController {
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

         let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
         child1.section = "WORLD"

         let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
         child2.section = "BUSINESS"
        
        let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
        child3.section = "POLITICS"
        
        let child4 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
        child4.section = "SPORTS"
        
        let child5 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
        child5.section = "TECHNOLOGY"
        
        let child6 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! HeadlinesChildViewController
        child6.section = "SCIENCE"

         return [child1, child2, child3, child4, child5, child6]
    }
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsController = storyboard.instantiateViewController(withIdentifier: "AutoSuggest") as! AutoSuggestTableViewController
        let search = UISearchController(searchResultsController: resultsController )
        search.searchResultsUpdater = resultsController
        search.searchBar.placeholder = "Enter keyword.."
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(getResult), name: Notification.Name("searchClicked"), object: nil)
    }
    
    @objc func getResult() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResultView") as! ResultViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func configureButtonBar() {
         // Sets the background colour of the pager strip and the pager strip item
         settings.style.buttonBarBackgroundColor = .white
         settings.style.buttonBarItemBackgroundColor = .white

         // Sets the pager strip item font and font color
         settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
         settings.style.buttonBarItemTitleColor = .gray
         // Sets the pager strip item offsets
         settings.style.buttonBarMinimumLineSpacing = 0
         settings.style.buttonBarItemsShouldFillAvailableWidth = true
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0

         // Sets the height and colour of the slider bar of the selected pager tab
         settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .systemBlue

         // Changing item text color on swipe
         changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
               oldCell?.label.textColor = .gray
            newCell?.label.textColor = .some(UIColor.systemBlue)
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

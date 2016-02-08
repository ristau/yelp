//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIScrollViewDelegate {

    var businesses: [Business]!
    var filteredData: [Business]!
    var searchController: UISearchController!
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()

        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
//searchController.dimsBackgroundDuringPresentation = false
        
        getFoodData()

}
        
func getFoodData(){

    Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        self.tableView.reloadData()
        
        for business in businesses {
            print(business.name!)
            print(business.address!)
        }
    })
}
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
  
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if businesses != nil {
        return businesses!.count
    } else {
        return 0
    }
}
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
    cell.business = businesses[indexPath.row]
    return cell
}
    
func scrollViewDidScroll(scrollView: UIScrollView){
    if(!isMoreDataLoading) {
        
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
            isMoreDataLoading = true

        // code to load more results
            loadMoreData()
    }
    
    }
}
    
func loadMoreData() {

}

    
func updateSearchResultsForSearchController(searchController: UISearchController){
    if filteredData == nil{
        filteredData = businesses
    }
    
    if let searchText = searchController.searchBar.text {
        if(searchText == "") {
            businesses = filteredData
            tableView.reloadData()
        } else {
             businesses = searchText.isEmpty ? businesses : businesses?.filter({(dataItem:Business) -> Bool in
                dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            tableView.reloadData()
        }
    }
}

}
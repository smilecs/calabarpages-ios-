//
//  TableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var TableData:Array<DataModel> = Array<DataModel>()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    var Searchfilter:Array<DataModel> = Array<DataModel>()
        override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data("https://calabaryellowpages.herokuapp.com/api/getcat")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.whiteColor()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let categoryList:SearchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("searchResult") as! SearchViewController
        categoryList.QueryString = searchBar.text!
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.presentViewController(categoryList, animated: true, completion: nil)
        })
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            let item = self.TableData[indexPath.row]
            cell.label?.text = item.Title
            return cell

        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataToPass = TableData[indexPath.row]
        let categoryList:CategoryListController = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryList") as! CategoryListController
            categoryList.slug = dataToPass.Slug
            categoryList.categoryName = dataToPass.Title
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                       self.presentViewController(categoryList, animated: true, completion: nil)
            })
     
        
    }
    
    func get_data(url:String)
    {
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest){
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                for item in jsonResult{
                    let tm = item as! NSDictionary
                    let dataModel:DataModel = DataModel()
                   
                        dataModel.Title = tm["Category"] as! String
                        dataModel.Slug = tm["Slug"]as! String
                   
                    
                    self.TableData.append(dataModel)
                
                }
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.tableView.reloadData()
                })
                
            }
            catch{
                
            }
        }
        task.resume()
        
    }


 
}

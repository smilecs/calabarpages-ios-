//
//  TableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var TableData:Array<DataModel> = Array<DataModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        get_data("https://calabaryellowpages.herokuapp.com/api/getcat")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let item = self.TableData[indexPath.row]
        cell.label?.text = item.Title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataToPass = TableData[indexPath.row]
        let categoryList:CategoryListController = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryList") as! CategoryListController
        categoryList.slug = dataToPass.Slug
        categoryList.categoryName = dataToPass.Title
        self.presentViewController(categoryList, animated: true, completion: nil)
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
                    self.tableView.reloadData()
                })
                
            }
            catch{
                
            }
        }
        task.resume()
        
    }


 
}

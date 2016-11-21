//
//  PlusTableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusTableViewController: UITableViewController {
    var TableData:Array<DataModel> = Array<DataModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        get_data("https://calabaryellowpages.herokuapp.com/api/falseview?page=1")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlusViewCell
        let item = TableData[indexPath.row]
        cell.title?.text = item.Title
        cell.address?.text = item.Address
        cell.specialisation?.text = item.Specialisation
        cell.workDays?.text = item.WorkDays
        cell.phone?.text = item.Phone
        return cell
    }
    

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let data = jsonResult["Data"] as! NSArray
                for item in data{
                    let tm = item as! NSDictionary
                    let dataModel:DataModel = DataModel()
                    dataModel.Title = tm["CompanyName"] as! String
                    dataModel.Slug = tm["Slug"]as! String
                    dataModel.Phone = tm["Hotline"] as! String
                    dataModel.Address = tm["Address"] as! String
                    dataModel.Specialisation = tm["Specialisation"] as! String
                    dataModel.WorkDays = tm["Dhr"] as! String
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

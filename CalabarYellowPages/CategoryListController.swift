//
//  CategoryListController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/21/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class CategoryListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var Tableview: UITableView!
    var slug = ""
    var categoryName = ""
    var TableData:Array<DataModel> = Array<DataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tableview.delegate = self
        self.Tableview.dataSource = self

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

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = TableData[indexPath.row]
        var cell:CategoryListViewCell
        switch data.Type{
            case "false":
                cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CategoryListViewCell
                
                cell.Title?.text = data.Title
                cell.Address?.text = data.Address
                cell.WorkDays?.text = data.WorkDays
                cell.Phone?.text = data.Phone
                cell.Specialisation?.text = data.Specialisation
            break
            case "true":
                cell = tableView.dequeueReusableCellWithIdentifier("plus", forIndexPath: indexPath) as! CategoryListViewCell
                
                cell.Title?.text = data.Title
                cell.Address?.text = data.Address
                cell.WorkDays?.text = data.WorkDays
                cell.Phone?.text = data.Phone
                cell.Specialisation?.text = data.Specialisation
            break
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("advert", forIndexPath: indexPath) as! CategoryListViewCell
            
           /*input advert image*/
            break
            
        }
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

}

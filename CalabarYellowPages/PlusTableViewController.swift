//
//  PlusTableViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var TableData:Array<DataModel> = Array<DataModel>()
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    var page:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.searchbar.delegate = self
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

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return TableData.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastElement = TableData.count - 1
        if indexPath.row == lastElement {
            page += 1
            let string = String(page)
            get_data("https://calabaryellowpages.herokuapp.com/api/falseview?page="+string)
        }
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

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlusViewCell
            let item = TableData[indexPath.row]
            cell.title?.text = item.Title
            cell.Address?.text = item.Address
            cell.special?.text = item.Specialisation
            cell.workDays?.text = item.WorkDays
            cell.Phone?.text = item.Phone
            if let url = NSURL(string: item.Image), datas = NSData(contentsOfURL: url){
                cell.plusLogo.image = UIImage(data: datas)
            
        }
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataToPass = TableData[indexPath.row]
        if(dataToPass.Type == "true"){
            let categoryList:PlusViewController = self.storyboard?.instantiateViewControllerWithIdentifier("plusDetailView") as! PlusViewController
            categoryList.Address = dataToPass.Address
            categoryList.titleM = dataToPass.Title
            categoryList.ImageAray = dataToPass.ImageAray
            categoryList.Description = dataToPass.Description
            categoryList.phone = dataToPass.Phone
            categoryList.work = dataToPass.WorkDays
            categoryList.special = dataToPass.Specialisation
            categoryList.web = dataToPass.Web
            categoryList.logo = dataToPass.Image
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.presentViewController(categoryList, animated: true, completion: nil)
            })

        }
        
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
                    dataModel.Title = (tm["CompanyName"] as! String?)!
                    dataModel.Slug = (tm["Slug"]as! String?)!
                    dataModel.Phone = (tm["Hotline"] as! String?)!
                    dataModel.Address = (tm["Address"] as! String?)!
                    dataModel.Specialisation = (tm["Specialisation"] as! String?)!
                    dataModel.Description = (tm["About"] as! String?)!
                    dataModel.WorkDays = (tm["Dhr"] as! String?)!
                    dataModel.Image = (tm["Image"] as! String?)!
                    for itms in (tm["Images"] as! NSArray?)!
                    
                    
                    {
                        dataModel.ImageAray.append(itms as! String)
                    }
                    self.TableData.append(dataModel)
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.table.reloadData()
                })
                
            }
            catch{
                
            }
        }
        task.resume()
        
    }


}

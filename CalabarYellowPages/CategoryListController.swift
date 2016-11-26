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
    var page:Int = 1
    var TableData:Array<DataModel> = Array<DataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tableview.delegate = self
        self.Tableview.dataSource = self
        //api/newview?page=" + page + "&q=
        get_data("https://calabaryellowpages.herokuapp.com/api/newview?page=1&q="+slug)
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
                if let url = NSURL(string: data.Image), datas = NSData(contentsOfURL: url){
                    cell.logo?.image = UIImage(data: datas)
                    
                }
                cell.Title?.text = data.Title
                cell.Address?.text = data.Address
                cell.WorkDays?.text = data.WorkDays
                cell.Phone?.text = data.Phone
                cell.Specialisation?.text = data.Specialisation
            break
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("advert", forIndexPath: indexPath) as! CategoryListViewCell
            if let url = NSURL(string: data.Image), datas = NSData(contentsOfURL: url){
                cell.Advert?.image = UIImage(data: datas)
         
            }
            break
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastElement = TableData.count - 1
        if indexPath.row == lastElement {
            page += 1
            let string = String(page)
            get_data("https://calabaryellowpages.herokuapp.com/api/newview?page="+string+"&q="+slug)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataToPass = TableData[indexPath.row]
        if dataToPass.Type == "true"{
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
            self.presentViewController(categoryList, animated: true, completion: nil)
        }
        
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
                    dataModel.Type = tm["Type"] as! String
                    dataModel.Image = tm["Image"] as! String
                    dataModel.Web = tm["Website"] as! String
                    self.TableData.append(dataModel)
                    print(dataModel.Title)
                    
                }
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.Tableview.reloadData()
                })
                
            }
            catch{
                
            }
        }
        task.resume()
        
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

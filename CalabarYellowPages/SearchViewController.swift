//
//  SearchViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/30/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
   
    var indicator = UIActivityIndicatorView()
    var QueryString: String = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var TableData:Array<DataModel> = Array<DataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.backBarButtonItem = back
        self.navBar.leftBarButtonItem = back
        self.navBar.leftItemsSupplementBackButton = true
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        get_data("https://calabaryellowpages.herokuapp.com/api/result?page=1&q=" + QueryString)
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.whiteColor()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return TableData.count
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
               
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        get_data("https://calabaryellowpages.herokuapp.com/api/result?page=1&q=" + searchBar.text!)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(TableData[indexPath.row].Type == "true"){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            let item = TableData[indexPath.row]
            cell.SearchTitle?.text = item.Title
            cell.SearchAddress?.text = item.Address
            cell.SearchSpecialisation?.text = item.Specialisation
            cell.SearchWorkDay?.text = item.WorkDays
            cell.SearchPhone?.text = item.Phone
            if let url = NSURL(string: item.Image), datas = NSData(contentsOfURL: url){
                cell.SearchLogo.image = UIImage(data: datas)
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! TableViewCell
            let item = TableData[indexPath.row]
            cell.SearchTitle?.text = item.Title
            cell.SearchAddress?.text = item.Address
            cell.SearchSpecialisation?.text = item.Specialisation
            cell.SearchWorkDay?.text = item.WorkDays
            cell.SearchPhone?.text = item.Phone
            return cell
        }
        
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
                if ((jsonResult["Data"] as? String) != nil) {
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
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.tableView.reloadData()
                    })
                }
                
               
                
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

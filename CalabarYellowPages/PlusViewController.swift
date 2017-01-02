//
//  PlusViewController.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/25/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var TableData:Array<DataModel> = Array<DataModel>()
    var Description = ""
    var titleM = ""
    var Address = ""
    @IBOutlet weak var CollectionView: UICollectionView!
    var Website = ""
    var special = ""
    var work = ""
    var phone = ""
    var logo = ""
    var web = ""
    @IBOutlet weak var itit: UINavigationItem!
    var ImageAray:[String] = []
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLogo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workLabels: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var tit: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        profileLogo.layer.borderWidth = 1
        profileLogo.layer.masksToBounds = false
        profileLogo.layer.borderColor = UIColor.white.cgColor
        profileLogo.layer.cornerRadius = profileLogo.frame.height/2
        profileLogo.clipsToBounds = true
        if let url = URL(string: logo), let datas = try? Data(contentsOf: url){
            profileLogo.image = UIImage(data: datas)
        }
        descriptionLabel?.text = Description
        addressLabel?.text = Address
        workLabels?.text = work
        specialLabel?.text = special
        webLabel?.text = web
        phoneLabel?.text = phone
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageAray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = ImageAray[indexPath.row]
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if let url = URL(string: data), let datas = try? Data(contentsOf: url){
            cell.gallery?.image = UIImage(data: datas)
            
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

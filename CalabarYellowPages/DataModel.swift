//
//  DataModel.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import Foundation

class DataModel{
    var Title:String
    var Address:String
    var WorkDays:String
    var Phone:String
    var Slug:String
    var Type:String
    var ImageAray:[String]
    var Web:String
    var Image, Specialisation:String
    var Description:String
    init(){
        self.Web = ""
        self.ImageAray = []
        self.Address = ""
        self.Description = ""
        self.Image = ""
        self.Phone = ""
        self.Specialisation = ""
        self.Title = ""
        self.WorkDays = ""
        self.Slug = ""
        self.Type = ""
    }
}


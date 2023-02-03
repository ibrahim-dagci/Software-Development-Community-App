//
//  GetPersonFromFirestore.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 21.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit


class GetPerson {
    
    var userId:String?
        
    
    var name:String?
    var surName:String?
    var userName:String?
    var department:String?
    var classs:String?
    var area:String?
    var bio:String?
    var gender:String?
    var pptUrl:String?
    var level:String?
    var status:String?
    var account:String?
    
    
    init(userId:String) {
        self.userId = userId
        getDataFromFirestore()
    }
    
    init(name:String,surName:String,userName:String,bio:String,pptUrl:String,account:String,department:String,classs:String,area:String,gender:String){
        self.name = name
        self.surName = surName
        self.userName = userName
        self.bio = bio
        self.pptUrl = pptUrl
        self.account = account
        self.department = department
        self.area = area
        self.classs = classs
        self.gender = gender
        
    }
    
    init() {
        
    }
    
    
    
    func getDataFromFirestore(){
        
        let db = Firestore.firestore()
        if let uid = userId{
            db.collection("Members").document(uid).getDocument { snapshot, error in
                if error != nil{
                    
                }
                else{
                    
                    if let name = snapshot?.get("name") as? String
                    {
                        self.name=name
                    }
                    
                    if let surName = snapshot?.get("surName") as? String
                    {
                        self.surName = surName
                    }
                    
                    if let userName = snapshot?.get("userName") as? String
                    {
                        self.userName = userName
                    }
                    
                    if let dprtmnt = snapshot?.get("department") as? String
                    {
                        self.department = dprtmnt
                    }
                    if let classs = snapshot?.get("clas") as? String
                    {
                        self.classs = classs
                    }
                    
                    if let area = snapshot?.get("area") as? String
                    {
                        self.area = area
                    }
                    
                    if let bio = snapshot?.get("biography") as? String
                    {
                        self.bio = bio
                    }
                    
                    if let ppurl = snapshot?.get("profilePhotoUrl") as? String
                    {
                        self.pptUrl = ppurl
                        
                    }
                    if let gender = snapshot?.get("gender") as? String
                    {
                        self.gender = gender
                    }
                    
                    if let account = snapshot?.get("account") as? String
                    {
                        self.account = account
                    }
                    
                    
                }
            }
        }
        
    }
    
    
    
}

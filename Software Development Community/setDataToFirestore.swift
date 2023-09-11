//
//  setDataToFirestore.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 27.01.2023.
//

import Foundation
import FirebaseFirestore
import Firebase
import UIKit

class setDataToFirestore{
    var collection:String?
    var data:[String:Any]?
    var document:String?
    var storageChild:String?
    let firestoreDataBase = Firestore.firestore()
    let storage = Storage.storage()
    
    
    init(collection: String, data: [String : Any], document: String) {
        self.collection = collection
        self.data = data
        self.document = document
    }
    
    init(collection: String, data: [String : Any]) {
        self.collection = collection
        self.data = data
    }
    
    init(collection: String, data: [String : Any], document: String,storageChild:String) {
        self.collection = collection
        self.data = data
        self.document = document
        self.storageChild = storageChild
    }
    init(collection: String, data: [String : Any],storageChild:String) {
        self.collection = collection
        self.data = data
        self.storageChild = storageChild
    }
    
    
    func setData(){
        self.firestoreDataBase.collection(collection!).document(document!).setData(data!, merge: true, completion:
        { error in
            if error != nil
            {
            }
            else
            {
            }
        })
    }
    
    func setDocument(){
        firestoreDataBase.collection(collection!).addDocument(data: data!, completion:
        { error in
            if error != nil
            {
                
            }
            else
            {
                
                
            }
        })
    }
    
    func setPublish(dataImage:UIImage,urlName:String){
        var ImageDownloadUrl:String?
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child(storageChild!)
        if let data = dataImage.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { storagemetadata, error in
                if error != nil{
                    
                }
                else{
                    imageReferance.downloadURL { url, error in
                        if error != nil{
                            
                        }
                        else{
                            ImageDownloadUrl = url!.absoluteString
                            let publishData = ["\(urlName)":ImageDownloadUrl!,"firebaseDate":FieldValue.serverTimestamp()] as [String:Any]
                            self.data!.merge(publishData){(current, _) in current}
                            self.setDocument()
                        }
                    }
                }
            }
        }
    }
}

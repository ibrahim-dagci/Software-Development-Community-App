//
//  setDataToFirestore.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 27.01.2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class setDataToFirestore{
    var collection:String?
    var data:[String:Any]?
    var userUid:String?
    let firestoreDataBase = Firestore.firestore()
    
    init(collection: String, data: [String : Any], userUid: String) {
        self.collection = collection
        self.data = data
        self.userUid = userUid
        setData()
    }
    
    func setData(){
        self.firestoreDataBase.collection(collection!).document(userUid!).setData(data!, merge: true, completion:
        { error in
            if error != nil
            {
            }
            else
            {
            }
        })
    }
    
}

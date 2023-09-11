//
//  ViewControllerPostComments.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.09.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewControllerPostComments: UIViewController {
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var postAndCommentsTableView: UITableView!
    let FirestoreDatabase = Firestore.firestore()
    private var comments = [String]()
    private var firebaseDates = [Timestamp]()
    private var memberGenders = [String]()
    private var memberNames = [String]()
    private var memberSurNames = [String]()
    private var memberPhotoUrls = [String]()
    var post:[String : Any]?
    var currentUser = GetPerson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommentDataFromFirestore()
        designInitialize()
        setupInit()
        postAndCommentsTableView.delegate = self
        postAndCommentsTableView.dataSource = self
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
        object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func sendButtonClick(_ sender: Any) {
        if commentField.text != ""{
            if let postId = post?["postId"] as? String{
                setDataToFirestore(collection: "Comment", data: ["firebaseDate":FieldValue.serverTimestamp(),"comment":commentField.text,"commentId":UUID().uuidString,"lineId":1,"memberGender":currentUser.gender,"memberName":currentUser.name,"memberPhotoUrl":currentUser.pptUrl,"memberSurname":currentUser.surName,"memberUid":currentUser.userId,"postId":postId] as [String:Any]).setDocument()
                commentField.text = ""
            }
        }
    }
    
    func designInitialize(){
        commentField.layer.cornerRadius = 17
        commentField.layer.borderWidth = 1
        commentField.layer.borderColor = UIColor.blue.cgColor
    }
    func commeDataCustomOrderByDate(){
         
    }
    
    func getCommentDataFromFirestore()
    {
        if let postId = post?["postId"] as? String{
            let collection = FirestoreDatabase.collection("Comment")
            let filter = collection.whereField("postId", isEqualTo: postId)
            let order = collection.order(by: "firebaseDate")
            filter.addSnapshotListener
            { snapshot, error in
                if error != nil {
                    print("eroororororoorororororor")
                    print(error?.localizedDescription)
                    print("eroororororoorororororor")
                }
                else
                {
                    if snapshot?.isEmpty != true
                    {
                        //remove arraye for do not be loop the feed
                        self.comments.removeAll(keepingCapacity: false)
                        self.firebaseDates.removeAll(keepingCapacity: false)
                        self.memberGenders.removeAll(keepingCapacity: false)
                        self.memberPhotoUrls.removeAll(keepingCapacity: false)
                        self.memberNames.removeAll(keepingCapacity: false)
                        self.memberSurNames.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents
                        {
                            //  initialize
                            if let comment = document.get("comment") as? String
                            {
                                self.comments.append(comment)
                            }
                            if let date = document.get("firebaseDate") as? Timestamp
                            {
                                self.firebaseDates.append(date)
                            }
                            if let url = document.get("memberPhotoUrl") as? String
                            {
                                self.memberPhotoUrls.append(url)
                            }
                            if let gender = document.get("memberGender") as? String
                            {
                                self.memberGenders.append(gender)
                            }
                            if let name = document.get("memberName") as? String
                            {
                                self.memberNames.append(name)
                            }
                            if let SurName = document.get("memberSurname") as? String
                            {
                                self.memberSurNames.append(SurName)
                            }
                        }
                        print(self.comments.count)
                        print(self.firebaseDates.count)
                        self.postAndCommentsTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ViewControllerPostComments: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return firebaseDates.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        else {
            return "Yorumlar"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell1 = postAndCommentsTableView.dequeueReusableCell(withIdentifier: "postCell") as! TableViewCellPostwithComments1
            if let postData = post{
                cell1.postCommentLabel.text = postData["comment"] as? String
                let uploadDateTimestam = postData["date"] as! Timestamp
                let uploadDate = uploadDateTimestam.dateValue()
                cell1.dayCounterLabel.text = dateDiff(frontDate:uploadDate, now: Date())
                cell1.postImageView.sd_setImage(with: URL(string: postData["postPhotoUrl"] as! String), placeholderImage: UIImage(named: "galleryPlaceholderImage"))
            }
            
            return cell1
        }
        else{
            let cell2 = postAndCommentsTableView.dequeueReusableCell(withIdentifier: "commentCell") as! TableViewCellPostwithComments2
            let uploadDateTimestamp = firebaseDates[indexPath.row]
            let uploadDate = uploadDateTimestamp.dateValue()
            cell2.dayCounterLabel.text = dateDiff(frontDate: uploadDate, now: Date())
            cell2.rootNameLabel.text = "\(memberNames[indexPath.row]) \(memberSurNames[indexPath.row])"
            cell2.rootCommentLabel.text = comments[indexPath.row]
            if memberGenders[indexPath.row] == "0"{
                cell2.rootImageView.sd_setImage(with: URL(string: memberPhotoUrls[indexPath.row]), placeholderImage: UIImage(named: "genderphmen"))
            }
            else{
                cell2.rootImageView.sd_setImage(with: URL(string: memberPhotoUrls[indexPath.row]), placeholderImage: UIImage(named: "genderphwomen"))
            }
            return cell2
        }
    }
    
    func dateDiff(frontDate:Date,now:Date) -> String{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: frontDate, to: now)
        if let year = components.year, let month = components.month, let day = components.day,
            let hour = components.hour, let minute = components.minute, let second = components.second {
            if year > 0 {
                return "\(year) yıl önce"
            }
            else if month > 0 {
                return "\(month) ay önce"
            }
            else if day > 0 {
                return "\(day) gün önce"
            }
            else if hour > 0 {
                return "\(hour) saat önce"
            }
            else if minute > 0 {
                return "\(minute) dakika önce"
            }
            else if second >= 0 {
                return "\(second) saniye önce"
            }
            else{
                return "hesaplanamadı"
            }
        } else {
            return "hesaplanamadı"
        }
    }
}

extension ViewControllerPostComments{
    func setupInit(){
        let touchSensor = UITapGestureRecognizer(target: self, action: #selector(self.touchTheFreeArea))
        view.addGestureRecognizer(touchSensor)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func touchTheFreeArea(){
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification){
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = -keyboardHeight
            self.view.frame.origin.y = bottomSpace
        }
    }
    
    @objc private func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    
}

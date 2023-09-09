//
//  ViewControllerFeed.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class ViewControllerFeed: UIViewController {
    @IBOutlet weak var goPublishButton: UIBarButtonItem!
    @IBOutlet weak var postTableView: UITableView!
    let currentUser = GetPerson(userId: Auth.auth().currentUser!.uid)
    var checkhing:Int?
    var timer = Timer()
    var time = 0;
    var isSuperUserControl:Bool?
    let FirestoreDatabase = Firestore.firestore()
    private var comments = [String]()
    private var dates = [Timestamp]()
    private var postOwners = [String]()
    private var postIds = [String]()
    private var postPhotoUrls = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        designInitialize()
        getFeedDataFromFirestore()
        
        
        if #available(iOS 16.0, *) {
            goPublishButton.isHidden = true
        } else {
            // Fallback on earlier versions
            isSuperUserControl =  false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.postTableView.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(changeBarHidden), userInfo:nil ,repeats : true )
        
    }
    
    @objc func changeBarHidden(){
        time+=1
        if let currentUserLevel = currentUser.level{
            if currentUserLevel == "2"{
                if #available(iOS 16.0, *) {
                    self.goPublishButton.isHidden = false
                    isSuperUserControl = true
                } else {
                    // Fallback on earlier versions
                    isSuperUserControl = true
                }
            }
            if   currentUser.status != true && checkhing == nil{
                AlertView.instance.showAlert(message: " Gerekli evrakları topluluğumuza teslim ettikten sonra profiliniz aktifleşecektir.", alertImageName: "checking",header: "HOŞGELDİNİZ !!!")
                checkhing = 1
            }
            timer.invalidate()
        }
        if time > 20 {
            time = 0
            timer.invalidate()
        }
    }
    

    @IBAction func goPublish(_ sender: Any) {
        if isSuperUserControl == true{
            performSegue(withIdentifier: "feedToPublish", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedToPublish"{
            let aimVC = segue.destination as! ViewControllerPublish
            aimVC.controlPublishType = false
            aimVC.currentUserUid = currentUser.userId
        }
    }
    

}

extension ViewControllerFeed {
    
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.title = "ANASAYFA"
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
}

extension ViewControllerFeed:UITableViewDelegate,UITableViewDataSource {
    
    func getFeedDataFromFirestore()
    {
        FirestoreDatabase.collection("Post").order(by: "firebaseDate", descending: true).addSnapshotListener
        { snapshot, error in
            if error != nil {
                
            }
            else
            {
                if snapshot?.isEmpty != true
                {
                    //remove arraye for do not be loop the feed
                    self.comments.removeAll(keepingCapacity: false)
                    self.dates.removeAll(keepingCapacity: false)
                    self.postPhotoUrls.removeAll(keepingCapacity: false)
                    self.postIds.removeAll(keepingCapacity: false)
                    self.postOwners.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents
                    {
                        //  initialize
                        if let comment = document.get("comment") as? String
                        {
                            self.comments.append(comment)
                        }
                        if let date = document.get("firebaseDate") as? Timestamp
                        {
                            self.dates.append(date)
                            print(date)
                        }
                        if let url = document.get("postPhotoUrl") as? String
                        {
                            self.postPhotoUrls.append(url)
                        }
                        if let owner = document.get("memberUid") as? String
                        {
                            self.postOwners.append(owner)
                        }
                        if let id = document.get("postId") as? String
                        {
                            self.postIds.append(id)
                        }
                    }
                    self.postTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postIds.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! UITableViewPostCell
        cell.postCommentLabel.text = comments[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: postPhotoUrls[indexPath.row]), placeholderImage: UIImage(named: "galleryPlaceholderImage"))
        cell.postIdLabel.text = postIds[indexPath.row]
        let uploadTimestamp = dates[indexPath.row]
        let now = Date()
        let uploadDate = uploadTimestamp.dateValue()
        cell.dayCounterLabel.text = dateDiff(frontDate: uploadDate, now: now)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "postToComments", sender: postIds[indexPath.row])
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

//
//  ViewControllerProfile.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ViewControllerProfile: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var biographyText: UITextView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var accountText: UITextView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dprtmntAndClassLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    
    var me = GetPerson(userId: Auth.auth().currentUser!.uid)
    private var meLoaded = 0
    var meOrMember = 0
    var dataMemberUid:String?
    var timer = Timer()
    var time = 0;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        designInitialize()
        loadProfileData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if meLoaded > 0 && meOrMember == 0 {
            self.me = GetPerson()
            if let cuuid = Auth.auth().currentUser?.uid {
                self.me = GetPerson(userId: cuuid)
            }
            
        }
        else if meLoaded > 0 && meOrMember == 1{
            if let dataMember = dataMemberUid{
                self.me = GetPerson()
                self.me = GetPerson(userId: dataMember)
            }
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        meLoaded = meLoaded+1
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(changeProfileData), userInfo:nil ,repeats : true )
        
    }
    @objc func changeProfileData(){
        time+=1
        if let name = me.userName, let surname = me.surName, let userName = me.userName,
           let bio = me.bio, let pptUrl = me.pptUrl, let account = me.account, let department = me.department, let classs = me.classs, let area = me.area, let gender = me.gender, let status = me.status, let level = me.level{
            self.loadProfileData()
            timer.invalidate()
        }
        if time > 20 {
            time = 0
            timer.invalidate()
        }
        
    }
    

    
    

}
extension ViewControllerProfile {
    
    func designInitialize(){
        //design initialize_____________________________________________________________
        let menu = UIMenu(title: "",  children: [
            UIAction(title: "Profili Düzenle", image: UIImage(systemName: "pencil"), handler: { (_) in
                self.performSegue(withIdentifier: "profileToEdit", sender: 1)
 
            }),
            UIAction(title: "İletişim", image: UIImage(systemName: "envelope"), handler: { (_) in
                print("İletişim clicked")
                
            }),
            UIAction(title: "Çıkış", image: UIImage(systemName: "power"), handler: { (_) in
                do {
                    try Auth.auth().signOut()
                    self.performSegue(withIdentifier: "signOut", sender: nil)
                }catch{
                    //this block will never start
                }
                    
            })
        ])
        
        self.navigationItem.title = "PROFİL"
        if meOrMember == 0{
            self.navigationItem.hidesBackButton = true
            self.menuButton.menu = menu
        }
        else if meOrMember == 1 {
            self.navigationItem.hidesBackButton = false
            if #available(iOS 16.0, *) {
                self.menuButton.isHidden = true
            } else {
                // Fallback on earlier versions
            }
  
        }
        
        
        
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        profileImage.layer.cornerRadius = 60
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.borderWidth = 3
        biographyText.layer.cornerRadius = 12
        biographyText.layer.borderColor = UIColor.gray.cgColor
        biographyText.layer.borderWidth = 2
        
    }
    
    func loadProfileData(){
        
        
        if let gender = me.gender{
            if gender == "0"{
                if let url = me.pptUrl{
                    profileImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "genderphmen"))
                }
                
            }
            else{
                
                if let url = me.pptUrl{
                    profileImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "genderphwomen"))
                }
            }
        }
            
        
        
        
        if let name = me.name
        {
            if let surName = me.surName
            {
                self.nameAndSurnameLabel.text = "\(name) \(surName)"
            }
        }
        
        if let userName = me.userName
        {
            self.userNameLabel.text = "@\(userName)"
        }
        
        if let dprtmnt = me.department
        {
            if let classs = me.classs
            {
                self.dprtmntAndClassLabel.text = "\(dprtmnt) / \(classs)"
            }
        }
        
        if let area = me.area
        {
            self.areaLabel.text = area
        }
        
        if let bio = me.bio
        {
            self.biographyText.text = bio
        }
        
        if let account = me.account{
            self.accountText.text = account
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profileToEdit"{
            if let data = sender as? Int{
                let aimVC = segue.destination as! ViewControllerUpdateInformation
                aimVC.updateOrRegister = data
                if let name = me.name, let surname = me.surName, let userName = me.userName,
                   let bio = me.bio, let pptUrl = me.pptUrl, let account = me.account, let department = me.department, let classs = me.classs, let area = me.area, let gender = me.gender, let status = me.status, let level = me.level{
                    aimVC.me = GetPerson(name: name, surName: surname, userName: userName, bio: bio, pptUrl: pptUrl, account: account,department: department,classs: classs,area: area,gender: gender,status: status,level: level)
                }
                
                
            }
            
        }
    }
}


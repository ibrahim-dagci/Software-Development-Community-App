//
//  ViewControllerMembers.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.


import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

class ViewControllerMembers: UIViewController, UIGestureRecognizerDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    private var memberNameArray = [String]()
    private var memberSurnameArray = [String]()
    private var memberAreaArray = [String]()
    private var memberEloArray = [String]()
    private var memberUidArray = [String]()
    private var memberPptUrlArray = [String]()
    private var memberGenderArray = [String]()
    private var memberStatusArray = [Bool]()
    // searching
    private var sMemberNameArray = [String]()
    private var sMemberSurnameArray = [String]()
    private var sMemberAreaArray = [String]()
    private var sMemberEloArray = [String]()
    private var sMemberUidArray = [String]()
    private var sMemberPptUrlArray = [String]()
    private var sMemberGenderArray = [String]()
    private var sMemberStatusArray = [Bool]()
    
    private let memberStatus = ["Üye","Yönetici","Başkan"]
    private var myElo:String?
    private var currenSearching = false
    

    @IBOutlet weak var membersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
        membersTableView.delegate = self
        membersTableView.dataSource = self
        getDataFromFirestore()
        setupLongPressGesture()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 2.0 // 1 second press
        longPressGesture.delegate = self
        self.membersTableView.addGestureRecognizer(longPressGesture)
        
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.membersTableView)
            
            if let indexPath = membersTableView.indexPathForRow(at: touchPoint) {
                
            }
        }
    }
    
    func designInitialize(){
        //design initialize______________________________________________________________
        
        self.navigationItem.title = "ÜYELER"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemberProfile"{
            let aimVC = segue.destination as! ViewControllerProfile
            aimVC.meOrMember = 1
            let memberUid = sender as! String
            aimVC.me = GetPerson(userId: memberUid)
            aimVC.dataMemberUid = memberUid
            
        }
    }
    
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oketButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(oketButton)
        self.present(alert, animated: true, completion: nil)
    }
}
extension ViewControllerMembers: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // member count returned
        if currenSearching == false{
            return memberUidArray.count
        }
        else{
            return sMemberUidArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // cell data init
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberTableViewCell
        cell.memberImageView.layer.cornerRadius = 40
        cell.memberImageView.layer.borderColor = UIColor.black.cgColor
        cell.memberImageView.layer.borderWidth = 2
        cell.containerView.layer.cornerRadius = 12
        cell.containerView.layer.borderColor = UIColor.gray.cgColor
        cell.containerView.layer.borderWidth = 1
        
        if currenSearching == false{
            cell.memberNameLabel.text = "\(memberNameArray[indexPath.row]) \(memberSurnameArray[indexPath.row])"
            cell.memberAreaLabel.text = memberAreaArray[indexPath.row]
            cell.userUidLabel.text = memberUidArray[indexPath.row]
            
            cell.memberElo.text = memberStatus[Int(memberEloArray[indexPath.row]) ?? 0]
           
            if memberGenderArray[indexPath.row] == "0"{
                cell.memberImageView.sd_setImage(with: URL(string:memberPptUrlArray[indexPath.row]), placeholderImage:UIImage(named: "genderphmen"))
            }
            else{
                cell.memberImageView.sd_setImage(with: URL(string:memberPptUrlArray[indexPath.row]), placeholderImage:UIImage(named: "genderphwomen"))
            }
             
            if memberStatusArray[indexPath.row] == false{
                cell.checkingImageView.image = UIImage(named: "waiting")
            }
            else{
                cell.checkingImageView.image = UIImage(named: "check")
            }
            return cell
        }
        else{
            cell.memberNameLabel.text = "\(sMemberNameArray[indexPath.row]) \(sMemberSurnameArray[indexPath.row])"
            cell.memberAreaLabel.text = sMemberAreaArray[indexPath.row]
            cell.userUidLabel.text = sMemberUidArray[indexPath.row]
            
            cell.memberElo.text = memberStatus[Int(sMemberEloArray[indexPath.row]) ?? 0]
           
            if sMemberGenderArray[indexPath.row] == "0"{
                cell.memberImageView.sd_setImage(with: URL(string:sMemberPptUrlArray[indexPath.row]), placeholderImage:UIImage(named: "genderphmen"))
            }
            else{
                cell.memberImageView.sd_setImage(with: URL(string:sMemberPptUrlArray[indexPath.row]), placeholderImage:UIImage(named: "genderphwomen"))
            }
             
            if sMemberStatusArray[indexPath.row] == false{
                cell.checkingImageView.image = UIImage(named: "waiting")
            }
            else{
                cell.checkingImageView.image = UIImage(named: "check")
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currenSearching == false{
            self.performSegue(withIdentifier: "toMemberProfile", sender: memberUidArray[indexPath.row])
        }
        else{
            self.performSegue(withIdentifier: "toMemberProfile", sender: sMemberUidArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
         
        if let elo = myElo{
            if currenSearching == false{
                if Int(elo)! >= 1 && Int(elo)! > Int( memberEloArray[indexPath.row])!{
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
                        
                        let activePassiveAction = UIAction(title: "Aktif/Pasif", image: UIImage(systemName: "checkmark"), identifier: nil, discoverabilityTitle: nil) { action in
                            if self.memberStatusArray[indexPath.row] == false{
                                
                                setDataToFirestore(collection: "Members", data:["status":true], userUid: self.memberUidArray[indexPath.row])
                            }
                            else if self.memberStatusArray[indexPath.row] == true{
                                setDataToFirestore(collection: "Members", data:["status":false], userUid: self.memberUidArray[indexPath.row])
                            }
                        }
                        let cancelAction = UIAction(title: "İptal", image: UIImage(systemName: "xmark"), identifier: nil, discoverabilityTitle: nil) { action in
                           
                        }
                        let deleteAction = UIAction(title: "Sil", image: UIImage(systemName: "xmark.bin"), identifier: nil, discoverabilityTitle: nil) { action in
                           
                        }
                        let subAction1 = UIAction(title: "Süper Yönetici", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"2"], userUid: self.memberUidArray[indexPath.row])
                           
                        }
                        let subAction2 = UIAction(title: "Yönetici", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"1"], userUid: self.memberUidArray[indexPath.row])
                           
                        }
                        let subAction3 = UIAction(title: "Üye", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"0"], userUid: self.memberUidArray[indexPath.row])
                           
                        }
                        var levelMenu = UIMenu()
                        
                        if Int(elo)! == 2{
                            levelMenu = UIMenu(title: "Seviye",image: UIImage(systemName: "person.2.fill"),children: [subAction1,subAction2,subAction3,cancelAction])
                        }
                        else{
                            levelMenu = UIMenu(title: "Seviye",image: UIImage(systemName: "person.2.fill"),children: [subAction2,subAction3,cancelAction])
                        }

                        
                        let popUpMenu = UIMenu(title: "Yönet", image: nil, identifier: nil, options: [], children: [activePassiveAction,levelMenu,deleteAction,cancelAction])
                        
                        return popUpMenu
                    }
                }
            }
            else{
                if Int(elo)! >= 1 && Int(elo)! > Int( sMemberEloArray[indexPath.row])!{
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
                        
                        let activePassiveAction = UIAction(title: "Aktif/Pasif", image: UIImage(systemName: "checkmark"), identifier: nil, discoverabilityTitle: nil) { action in
                            if self.sMemberStatusArray[indexPath.row] == false{
                                
                                setDataToFirestore(collection: "Members", data:["status":true], userUid: self.sMemberUidArray[indexPath.row])
                            }
                            else if self.sMemberStatusArray[indexPath.row] == true{
                                setDataToFirestore(collection: "Members", data:["status":false], userUid: self.sMemberUidArray[indexPath.row])
                            }
                        }
                        let cancelAction = UIAction(title: "İptal", image: UIImage(systemName: "xmark"), identifier: nil, discoverabilityTitle: nil) { action in
                           
                        }
                        let deleteAction = UIAction(title: "Sil", image: UIImage(systemName: "xmark.bin"), identifier: nil, discoverabilityTitle: nil) { action in
                           
                        }
                        let subAction1 = UIAction(title: "Süper Yönetici", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"2"], userUid: self.sMemberUidArray[indexPath.row])
                           
                        }
                        let subAction2 = UIAction(title: "Yönetici", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"1"], userUid: self.sMemberUidArray[indexPath.row])
                           
                        }
                        let subAction3 = UIAction(title: "Üye", image: UIImage(systemName: "cancel"), identifier: nil, discoverabilityTitle: nil) { action in
                            setDataToFirestore(collection: "Members", data:["level":"0"], userUid: self.sMemberUidArray[indexPath.row])
                           
                        }
                        var levelMenu = UIMenu()
                        
                        if Int(elo)! == 2{
                            levelMenu = UIMenu(title: "Seviye",image: UIImage(systemName: "person.2.fill"),children: [subAction1,subAction2,subAction3,cancelAction])
                        }
                        else{
                            levelMenu = UIMenu(title: "Seviye",image: UIImage(systemName: "person.2.fill"),children: [subAction2,subAction3,cancelAction])
                        }

                        
                        let popUpMenu = UIMenu(title: "Yönet", image: nil, identifier: nil, options: [], children: [activePassiveAction,levelMenu,deleteAction,cancelAction])
                        
                        return popUpMenu
                    }
                }
            }
        }
        return nil
    }
    
    
    
    
    func getDataFromFirestore()
    {
        let FirestoreDatabase = Firestore.firestore()
        
        FirestoreDatabase.collection("Members").order(by: "dateOfRegistration", descending: true).addSnapshotListener
        { snapshot, error in
            if error != nil {
                self.alert(title: "Error", message: error?.localizedDescription ?? "Err")
            }
            else
            {
                if snapshot?.isEmpty != true
                {
                    //remove arraye for do not be loop the feed
                    self.memberNameArray.removeAll(keepingCapacity: false)
                    self.memberSurnameArray.removeAll(keepingCapacity: false)
                    self.memberEloArray.removeAll(keepingCapacity: false)
                    self.memberUidArray.removeAll(keepingCapacity: false)
                    self.memberAreaArray.removeAll(keepingCapacity: false)
                    self.memberPptUrlArray.removeAll(keepingCapacity: false)
                    self.memberGenderArray.removeAll(keepingCapacity: false)
                    self.memberStatusArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents
                    {
                        // member arrays initialize
                        if document.get("uid") as? String != Auth.auth().currentUser!.uid{
                            
                            if let memberName = document.get("name") as? String
                            {
                                self.memberNameArray.append(memberName)
                            }
                            
                            if let memberSurname = document.get("surName") as? String
                            {
                                self.memberSurnameArray.append(memberSurname)
                            }
                            
                            if let memberArea = document.get("area") as? String
                            {
                                self.memberAreaArray.append(memberArea)
                            }
                            
                            if let memberElo = document.get("level") as? String
                            {
                                self.memberEloArray.append(memberElo)
                            }
                            
                            if let memberUid = document.get("uid") as? String
                            {
                                self.memberUidArray.append(memberUid)
                            }
                            
                            if let memberPptUrl = document.get("profilePhotoUrl") as? String
                            {
                                self.memberPptUrlArray.append(memberPptUrl)
                            }
                            
                            if let memberGender = document.get("gender") as? String
                            {
                                self.memberGenderArray.append(memberGender)
                            }
                            if let memberStatus = document.get("status") as? Bool
                            {
                                self.memberStatusArray.append(memberStatus)
                            }
                        }
                        else{
                            if let elo = document.get("level") as? String {
                                self.myElo = elo
                            }
                        }
                    }
                    self.membersTableView.reloadData()
                    self.searchBar(self.searchBar, textDidChange: self.searchBar.text!)
                }
            }
        }
    }
}

extension ViewControllerMembers:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            currenSearching = false
        }
        else{
            currenSearching = true
            self.sMemberNameArray.removeAll(keepingCapacity: false)
            self.sMemberSurnameArray.removeAll(keepingCapacity: false)
            self.sMemberEloArray.removeAll(keepingCapacity: false)
            self.sMemberUidArray.removeAll(keepingCapacity: false)
            self.sMemberAreaArray.removeAll(keepingCapacity: false)
            self.sMemberPptUrlArray.removeAll(keepingCapacity: false)
            self.sMemberGenderArray.removeAll(keepingCapacity: false)
            self.sMemberStatusArray.removeAll(keepingCapacity: false)
            sMemberNameArray = memberNameArray.filter({
                // burda fazladan işlemi yaptığımı düşünüyorum fakat henüz bunu çözmek için vakit ayıramadım
                //(şimdilik çalışıyor)
                $0.lowercased().contains(searchText.lowercased())
            })
            var searchingIndexArray:[Int] = [Int]()
            var counter = 0
            var counter2 = 0
            if sMemberNameArray.isEmpty{
                
            }else{
                for member in memberNameArray{
                    if member == sMemberNameArray[counter2]{
                        searchingIndexArray.append(counter)
                        if sMemberNameArray.count == searchingIndexArray.count{
                            break
                        }
                        counter2+=1
                    }
                    counter+=1
                }
                for index in searchingIndexArray{
                    sMemberSurnameArray.append(memberSurnameArray[index])
                    sMemberAreaArray.append(memberAreaArray[index])
                    sMemberEloArray.append(memberEloArray[index])
                    sMemberUidArray.append(memberUidArray[index])
                    sMemberPptUrlArray.append(memberPptUrlArray[index])
                    sMemberGenderArray.append(memberGenderArray[index])
                    sMemberStatusArray.append(memberStatusArray[index])
                }
            }
            
        }
        self.membersTableView.reloadData()
    }
}

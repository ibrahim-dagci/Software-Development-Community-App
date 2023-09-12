//
//  ViewControllerGallery.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit
import Firebase

class ViewControllerGallery: UIViewController {

    @IBOutlet weak var goPublishButton: UIBarButtonItem!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    let currentUser = GetPerson(userId: Auth.auth().currentUser!.uid)
    var timer = Timer()
    var time = 0;
    var isSuperUserControl:Bool?
    private var comments = [String]()
    private var dates = [String]()
    private var galleryPhotoUrls = [String]()
    private var galleryPhotos = [UIImageView]()
    let FirestoreDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        designInitialize()
        if #available(iOS 16.0, *) {
            goPublishButton.isHidden = true
        } else {
            // Fallback on earlier versions
            isSuperUserControl =  false
        }
        getGalleryDataFromFirestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
            timer.invalidate()
        }
        if time > 20 {
            time = 0
            timer.invalidate()
        }
    }
    
    @IBAction func goPublish(_ sender: Any) {
        if isSuperUserControl == true{
            performSegue(withIdentifier: "galleryToPublish", sender: nil)
        }
    }
    
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.title = "GALERİ"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        self.navigationItem.hidesBackButton = true
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let collectionViewDesign:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = galleryCollectionView.frame.size.width
        collectionViewDesign.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cellWidth = (width-50)/4
        collectionViewDesign.itemSize = CGSize(width: cellWidth, height: cellWidth)
        galleryCollectionView!.collectionViewLayout = collectionViewDesign
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "galleryToPublish"{
            let aimVC = segue.destination as! ViewControllerPublish
            aimVC.controlPublishType = true
        }
    }
    
    
}
extension ViewControllerGallery:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func getGalleryDataFromFirestore()
    {
        FirestoreDatabase.collection("Gallery").order(by: "firebaseDate", descending: true).addSnapshotListener
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
                    self.galleryPhotoUrls.removeAll(keepingCapacity: false)
                    self.galleryPhotos.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents
                    {
                        //  initialize
                        if let comment = document.get("comment") as? String
                        {
                            self.comments.append(comment)
                        }
                        if let date = document.get("date") as? String
                        {
                            self.dates.append(date)
                        }
                        if let url = document.get("galleryPhotoUrl") as? String
                        {
                            self.galleryPhotoUrls.append(url)
                        }
                    }
                    self.galleryCollectionView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        cell.cellImageView.sd_setImage(with: URL(string: galleryPhotoUrls[indexPath.row]), placeholderImage: UIImage(named: "galleryPlaceholderImage"))
        galleryPhotos.append(cell.cellImageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewControllerGalleryImage()
        vc.selectedIndex = indexPath.row
        vc.imageArray = galleryPhotos
        vc.imageDateArray  = dates
        vc.imageCommentArray = comments
        pushView(viewControler: vc)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryPhotoUrls.count
    }
    
    
    
}

extension UIViewController{
    
    func pushView(viewControler:UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        self.view.window?.layer.add(transition, forKey : kCATransition)
        navigationController?.pushViewController(viewControler, animated: true)
        
    }
    
    func dismissView(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .fromBottom
        self.view.window?.layer.add(transition, forKey : kCATransition)
        navigationController?.popViewController(animated: true)
    }
}

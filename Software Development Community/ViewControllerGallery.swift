//
//  ViewControllerGallery.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit

class ViewControllerGallery: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        designInitialize()
        
        
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
}
extension ViewControllerGallery:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        cell.cellImageView.image = UIImage(named: "check")
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    
}

//
//  ViewControllerLock.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 23.02.2023.
//

import UIKit
import Firebase

class ViewControllerLock: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    var currentUser = GetPerson(userId: Auth.auth().currentUser!.uid )

    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
        if let currentUserStatus = currentUser.status  {
            if currentUserStatus == true{
                performSegue(withIdentifier: "lockToGallery", sender: nil)
            }
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let currentUserStatus = currentUser.status  {
            print(currentUserStatus)
            if currentUserStatus == true{
                lockImage.image = UIImage(named: "check")
                titleLabel.text = " "
                infoLabel.text = " "
                performSegue(withIdentifier: "lockToGallery", sender: nil)
            }
        }
    }
    

    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.title = ""
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

//
//  ViewControllerFeed.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit

class ViewControllerFeed: UIViewController {
    var checkhing:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()

        if let checkAlert = checkhing{
            AlertView.instance.showAlert(message: " Gerekli evrakları topluluğumuza teslim ettikten sonra profiliniz aktifleşecektir.", alertImageName: "checking",header: "HOŞGELDİNİZ !!!")
        }

        // Do any additional setup after loading the view.
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

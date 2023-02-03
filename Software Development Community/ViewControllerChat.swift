//
//  ViewControllerChat.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 9.10.2022.
//

import UIKit

class ViewControllerChat: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()

        // Do any additional setup after loading the view.
    }
    

    

}
extension ViewControllerChat {
    
    func designInitialize(){
        //design initialize______________________________________________________________
        
        self.navigationItem.title = "SOHBET"
        
        
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

//
//  ViewController.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 23.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var eMailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func logInButtonClick(_ sender: Any) {
        LoadingView.instance.showLoading()
        if eMailLabel.text != "" && passwordLabel.text != ""{
            Auth.auth().signIn(withEmail: eMailLabel.text!, password: passwordLabel.text!) { authdata, error in
                if error != nil {
                    LoadingView.instance.removeView()
                    LoadingView.instance.loading = false
                    self.alert(title: "Hata!", message: error?.localizedDescription ?? "Beklenmedik bir hatayla karşılaştık lütfen bağlantınızı veya giriş alanlarını kontrol ediniz. E postanızın formatının doğru olduğundan emin olunuz!")
                    
                }
                else{
                    
                    let verify = Auth.auth().currentUser?.isEmailVerified
                    if verify != nil{
                        if verify! {
                            let db = Firestore.firestore()
                            db.collection("Members").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid ).getDocuments { querySnapshot, error in
                                if error != nil {
                                    LoadingView.instance.removeView()
                                    LoadingView.instance.loading = false
                                    self.alert(title: "Hata!", message: error!.localizedDescription )
                                    
                                }
                                else{
                                    if querySnapshot!.documents.count > 0 {
                                        LoadingView.instance.removeView()
                                        LoadingView.instance.loading = false
                                        self.performSegue(withIdentifier: "LogInToFeed", sender: nil)
                                    }
                                    else{
                                        LoadingView.instance.removeView()
                                        LoadingView.instance.loading = false
                                        self.performSegue(withIdentifier: "logInToUpdate", sender: 0)
                                    }
                                }
                            }
                            
                            
                            
                        }
                        else{
                            LoadingView.instance.removeView()
                            LoadingView.instance.loading = false
                            self.alert(title: "Uyarı!", message: "Lütfen önce E-mail adresinizi doğrulayın")
                        }
                    }
                    else{
                        LoadingView.instance.removeView()
                        LoadingView.instance.loading = false
                        self.alert(title: "Hata!", message: "Bağlantı hatası!")
                    }
                    
                }
            }
        }
        else{
            LoadingView.instance.removeView()
            LoadingView.instance.loading = false
            alert(title: "Uyarı", message: "E posta veya şifre alanları boş bırakılmamalıdır!")
        }
    }
    @IBAction func forgotPasswordClick(_ sender: Any) {
        performSegue(withIdentifier: "LogInToForgotPassword", sender: nil)
    }
    
    @IBAction func registerButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "logInToRegister", sender: nil)
        
    }
}
extension ViewController {
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "GİRİŞ"
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        let envelopeButton = UIButton(type: .custom)
        let envelopeImage = UIImage(systemName: "envelope.fill")
        envelopeButton.setImage(envelopeImage, for: .normal)
        /*overlayButton.addTarget(self, action: #selector(displayBookmarks),
            for: .touchUpInside)
        overlayButton.sizeToFit()*/
        let lockButton = UIButton(type: .custom)
        let lockImage = UIImage(systemName: "lock.fill")
        lockButton.setImage(lockImage, for: .normal)
        /*overlayButton.addTarget(self, action: #selector(displayBookmarks),
            for: .touchUpInside)
        overlayButton.sizeToFit()*/
                
        // Assign the overlay button to the text field
        eMailLabel.leftView = envelopeButton
        eMailLabel.leftViewMode = .always
        passwordLabel.leftView = lockButton
        passwordLabel.leftViewMode = .always
        //____________________________________________________________________________
    
    }
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oketButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(oketButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInToUpdate"{
            if let data = sender as? Int{
                let aimVC = segue.destination as! ViewControllerUpdateInformation
                aimVC.updateOrRegister = data
            }
        }
    }

}

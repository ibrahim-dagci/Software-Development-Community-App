//
//  ViewControllerPasswordForgot.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 24.09.2022.
//

import UIKit
import FirebaseAuth

class ViewControllerPasswordForgot: UIViewController {

    @IBOutlet weak var eMailLabelForgetPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendNewPasswordClick(_ sender: Any) {
        LoadingView.instance.showLoading(currentVC: self)
        if eMailLabelForgetPassword.text != ""{
            Auth.auth().sendPasswordReset(withEmail: eMailLabelForgetPassword.text!) { error in
                if error != nil {
                    LoadingView.instance.removeView()
                    LoadingView.instance.loading = false
                    self.alert(title: "Hata", message: "Bu E-posta adresi sistemimizde kayıtlı değil!!!")
                    
                }
                else{
                    LoadingView.instance.removeView()
                    LoadingView.instance.loading = false
                    AlertView.instance.showAlert(message: "Şifrenizi E-postanıza gelen linkten güncelleyebilirsiniz.", alertImageName: "check",header: "")
                    self.performSegue(withIdentifier: "ForgotPasseordToLogIn", sender: nil)
                    
                }
            }
        }
        
    }
    
    
    @IBAction func goForLogInClickPF(_ sender: Any) {
        performSegue(withIdentifier: "ForgotPasseordToLogIn", sender: nil)
    }
    
}
extension ViewControllerPasswordForgot {
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "ŞİFREMİ UNUTTUM"
        
        let envelopeButton = UIButton(type: .custom)
        let envelopeImage = UIImage(systemName: "envelope.fill")
        envelopeButton.setImage(envelopeImage, for: .normal)
        eMailLabelForgetPassword.leftView = envelopeButton
        eMailLabelForgetPassword.leftViewMode = .always
        //_______________________________________________________________________________
    }
    
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oketButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(oketButton)
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  ViewControllerRegister.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 24.09.2022.
//

import UIKit
import FirebaseAuth

class ViewControllerRegister: UIViewController {

    @IBOutlet weak var passwordLabelAgain: UITextField!
    @IBOutlet weak var passwordLabelReg: UITextField!
    @IBOutlet weak var eMailLabelReg: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        //loading animation will initializing next line than remove every else block
        LoadingView.instance.showLoading()
        if eMailLabelReg.text != "" && passwordLabelReg.text != "" && passwordLabelAgain.text != ""{
            if passwordLabelAgain.text == passwordLabelReg.text && passwordLabelReg.text!.count >= 6 {
                Auth.auth().createUser(withEmail: eMailLabelReg.text!, password: passwordLabelReg.text!) { authdata, error in
                    
                    if error != nil {
                        LoadingView.instance.removeView()
                        LoadingView.instance.loading = false
                        
                        self.alert(title: "Hata!", message: String(error?.localizedDescription ?? "Beklenmedik bir hatayla karşılaştık lütfen bağlantınızı veya giriş alanlarını kontrol ediniz. E postanızın formatının doğru olduğundan emin olunuz!") )
                        
                    }
                    else{
                        Auth.auth().currentUser?.sendEmailVerification()
                        LoadingView.instance.removeView()
                        LoadingView.instance.loading = false
                        do{
                            try Auth.auth().signOut()
                            self.performSegue(withIdentifier: "RegisterToLogIn", sender: nil)
                        }catch {
                            print("Error")
                        }
                        
                        
                        AlertView.instance.showAlert(message: "E-postanıza gelen linki doğruladıktan sonra giriş yapabilirsiniz. ", alertImageName: "check",header: "")
                    }
                }
            }
            else{
                LoadingView.instance.removeView()
                LoadingView.instance.loading = false
                self.alert(title: "Uyarı!", message: "Girdiğiniz şifreler aynı olmalı ve en az altı karakter içermelidir!")
            }
            
        }
        else{
            LoadingView.instance.removeView()
            LoadingView.instance.loading = false
            self.alert(title: "Uyarı", message: "E posta ve şifre alanları boş bırakılmamalıdır!")
        }
        
    }
    @IBAction func goForLogInClick(_ sender: Any) {
        performSegue(withIdentifier: "RegisterToLogIn", sender: nil)
    }
    
    

}
extension ViewControllerRegister {
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.hidesBackButton = true
        
        
        
        let envelopeButton = UIButton(type: .custom)
        let envelopeImage = UIImage(systemName: "envelope.fill")
        envelopeButton.setImage(envelopeImage, for: .normal)
        
        let lockButton = UIButton(type: .custom)
        let lockImage = UIImage(systemName: "lock.fill")
        lockButton.setImage(lockImage, for: .normal)
        let lockButton2 = UIButton(type: .custom)
        lockButton2.setImage(lockImage, for: .normal)
                        
        // Assign the overlay button to the text field
        eMailLabelReg.leftView = envelopeButton
        eMailLabelReg.leftViewMode = .always
        passwordLabelReg.leftView = lockButton
        passwordLabelReg.leftViewMode = .always
        passwordLabelAgain.leftView = lockButton2
        passwordLabelAgain.leftViewMode = .always

        //____________________________________________________________________________
    }
    
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oketButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(oketButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

//
//  ViewControllerUpdateInformation.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 2.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase
import SDWebImage

class ViewControllerUpdateInformation: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var departmentLabel: UITextField!
    
    @IBOutlet weak var biographyLabel: UITextField!
    @IBOutlet weak var accountLabel: UITextField!
    @IBOutlet weak var classLabel: UITextField!
    @IBOutlet weak var areaLabel: UITextField!
    var pickerViewDepartment : UIPickerView?
    var departments:[String] = [String]()
    var pickerViewClasss : UIPickerView?
    var classs:[String] = [String]()
    var pickerViewArea : UIPickerView?
    var areas:[String] = [String]()
    var gender : String = "1"
    private var imageCureen = false
    var updateOrRegister = 3
    let fireStoreDatabase = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    var me : GetPerson?
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
        imageClickMaterials()
        //picker view input view -> textLabel ----------------
        departments = ["","Bilgisayar Mühendisliği","Yazılım Mühendisliği","Diğer"]
        classs = ["","1. sınıf","2. sınıf","3. sınıf","4. sınıf","Diğer"]
        areas = ["","Web Geliştirme","Mobil Programlama","Diğer"]
        //------------------------
        pickerViewArea = UIPickerView()
        pickerViewClasss = UIPickerView()
        pickerViewDepartment = UIPickerView()
        pickerViewArea?.delegate = self
        pickerViewArea?.dataSource = self
        pickerViewClasss?.delegate = self
        pickerViewClasss?.dataSource = self
        pickerViewDepartment?.delegate = self
        pickerViewDepartment?.dataSource = self
        departmentLabel.inputView = pickerViewDepartment
        classLabel.inputView = pickerViewClasss
        areaLabel.inputView = pickerViewArea
        // dokunma algılama -------------
        let touchSensor = UITapGestureRecognizer(target: self, action: #selector(self.touchTheFreeArea))
        view.addGestureRecognizer(touchSensor)
        
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        designInitialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    

    @IBAction func segmentedControlGender(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            gender = "1"
            
        }
        if sender.selectedSegmentIndex == 1 {
            gender = "0"
            
        }
    }
    @IBAction func saveClick(_ sender: Any) {
        if updateOrRegister == 0{
            register()
            
        }
        else if updateOrRegister == 1 {
            update()
        }
        
    }
    
    func designInitialize(){
        
        //design initialize______________________________________________________________
        if updateOrRegister == 0{
            self.navigationItem.hidesBackButton = true
        }
        self.navigationItem.title = "ÜYE BİLGİLERİ"
        let tailAButton = UIButton(type: .custom)
        let AImage = UIImage(systemName: "at")
        tailAButton.setImage(AImage, for: .normal)
        nickName.leftView = tailAButton
        nickName.leftViewMode = .always
        profileImage.layer.cornerRadius = 49
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.borderWidth = 3
        profileImage.contentMode = .scaleAspectFill
        if updateOrRegister == 1{
            // optional binding yapılacak...
            if me!.gender == "0"{
                profileImage.sd_setImage(with: URL(string: me!.pptUrl!), placeholderImage: UIImage(named: "genderphmen"))
            }
            else if me!.gender == "1"{
                profileImage.sd_setImage(with: URL(string: me!.pptUrl!), placeholderImage: UIImage(named: "genderphwomen"))
            }
            
            name.text = me!.name!
            surname.text = me!.surName!
            nickName.text = me!.userName!
            biographyLabel.text = me!.bio!
            accountLabel.text = me!.account!
            areaLabel.text = me!.area!
            classLabel.text = me!.classs!
            departmentLabel.text = me!.department!
        }
    }
    

}
extension ViewControllerUpdateInformation: UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // picker view funcs-------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewDepartment{
            return departments.count
        }
        else if pickerView == pickerViewClasss{
            return classs.count
        }
        else if pickerView == pickerViewArea{
            return areas.count
        }
        else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewDepartment{
            return departments[row]
        }
        else if pickerView == pickerViewClasss{
            return classs[row]
        }
        else if pickerView == pickerViewArea{
            return areas[row]
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewDepartment{
            departmentLabel.text = departments[row]
        }
        else if pickerView == pickerViewClasss{
            classLabel.text = classs[row]
        }
        else if pickerView == pickerViewArea{
            areaLabel.text = areas[row]
        }
        else{
            
        }
    }
    //-----------------------------------
}
    
extension ViewControllerUpdateInformation {
    
    
    
    @objc func touchTheFreeArea(){
        view.endEditing(true)
    }
    //galleri chooose image funcs --------
    func imageClickMaterials(){
        profileImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage) )
        profileImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        pickerControler.sourceType = .photoLibrary
        present(pickerControler, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImage.image = info[.originalImage] as? UIImage
        imageCureen = true
        
        self.dismiss(animated: true, completion: nil)
    }
    //------------------------------------------
}
    
extension ViewControllerUpdateInformation {
    
    func SetImageAndGetUrl(){
        
        if imageCureen == true{
            var ImageDownloadUrl:String = "err"
            let storage = Storage.storage()
            let storageReferance = storage.reference()
            let mediaFolder = storageReferance.child("profilePhoto")
            if let data = profileImage.image?.jpegData(compressionQuality: 0.5){
                let uuid = UUID().uuidString
                let imageReferance = mediaFolder.child("\(uuid).jpg")
                imageReferance.putData(data, metadata: nil) { storagemetadata, error in
                    if error != nil{
                        self.alert(title: "Hata!", message: error?.localizedDescription ?? "Err")
                    }
                    else{
                        imageReferance.downloadURL { url, error in
                            if error != nil
                            {
                                self.alert(title: "Error", message: error?.localizedDescription ?? "Err")
                            }
                            else{
                                ImageDownloadUrl = url!.absoluteString
                                let pptUrl = ["profilePhotoUrl":ImageDownloadUrl] as [String:Any]
                                
                                self.fireStoreDatabase.collection("Members").document(self.uid).setData(pptUrl, merge: true) { error in
                                    if error != nil{
                                       
                                    }
                                    else{
                                        if self.updateOrRegister == 1{
                                            LoadingView.instance.removeView()
                                            LoadingView.instance.loading = false
                                            self.navigationController?.popToRootViewController(animated: false)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if updateOrRegister == 0{
            let pptUrl = ["profilePhotoUrl":"null"] as [String:Any]
            self.fireStoreDatabase.collection("Members").document(self.uid).setData(pptUrl, merge: true)
        }
        else if self.updateOrRegister == 1{
            LoadingView.instance.removeView()
            LoadingView.instance.loading = false
            self.navigationController?.popToRootViewController(animated: false)
        }
        
    }
    
    func alert(title:String,message:String)
    {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func register(){
        LoadingView.instance.showLoading(currentVC: self)
        if nickName.text != "" && name.text != "" && surname.text != "" && departmentLabel.text != "" && areaLabel.text != "" && classLabel.text != ""{
            SetImageAndGetUrl()
            let language = Locale(identifier: "tr")

            let firestoreMember = ["account":accountLabel.text!,"area":areaLabel.text!,"biography":biographyLabel.text!,"clas":classLabel.text!,"dateOfRegistration":FieldValue.serverTimestamp(),"department":departmentLabel.text!,"gender":gender,"level":"0","name":name.text!.capitalized(with: language),"status": false,"surName":surname.text!.capitalized(with: language),"uid":uid,"userName":nickName.text!] as [String : Any]
            
             fireStoreDatabase.collection("Members").whereField("userName", isEqualTo: nickName.text!).getDocuments { querySnapshot, error in
                if error != nil{
                    LoadingView.instance.removeView()
                    LoadingView.instance.loading = false
                    self.alert(title: "Hata", message:error!.localizedDescription)
                }
                else{
                    if querySnapshot!.documents.count == 0 {
                        self.fireStoreDatabase.collection("Members").document(self.uid).setData(firestoreMember, merge: true, completion:
                        { error in
                            if error != nil
                            {
                                LoadingView.instance.removeView()
                                LoadingView.instance.loading = false
                                self.alert(title: "Error", message: error?.localizedDescription ?? "Err")
                            }
                            else
                            {
                                // aklında bulunsun fotoğraf yüklemeyi buraya alırsan SetImageAndGetUrl() geçişi yüklemenin içinde yap.
                                
                                self.performSegue(withIdentifier: "InformationToFeed", sender: nil)
                                
                                
                                
                                
                            }
                        })
                    }
                    else {
                        LoadingView.instance.removeView()
                        LoadingView.instance.loading = false
                        self.alert(title: "Uyarı", message: "Bu kullanıcı adı daha önce alındı.Lütfen farklı bir kullanıcı adı seçin!!")
                    }
                }
            }
            
            
        }
        else{
            LoadingView.instance.removeView()
            LoadingView.instance.loading = false
            alert(title: "Uyarı", message: "Lütfen gerekli alanları doldurduğunuzdan ve seçim gerektiren alanların dolu olduğundan emin olun")
        }
    }
    
    func update(){
        LoadingView.instance.showLoading(currentVC: self)
        if nickName.text != "" && name.text != "" && surname.text != "" && departmentLabel.text != "" && areaLabel.text != "" && classLabel.text != ""{
            
            let language = Locale(identifier: "tr")

            let firestoreMember = ["account":accountLabel.text!,"area":areaLabel.text!,"biography":biographyLabel.text!,"clas":classLabel.text!,"dateOfRegistration":FieldValue.serverTimestamp(),"department":departmentLabel.text!,"gender":gender,"level":me!.level,"name":name.text!.capitalized(with: language),"status": me!.status,"surName":surname.text!.capitalized(with: language),"uid":uid,"userName":nickName.text!] as [String : Any]
            
             fireStoreDatabase.collection("Members").whereField("userName", isEqualTo: nickName.text!).getDocuments { querySnapshot, error in
                if error != nil{
                    LoadingView.instance.removeView()
                    LoadingView.instance.loading = false
                    self.alert(title: "Hata", message:error!.localizedDescription)
                }
                else{
                    if querySnapshot!.documents.count <= 1 {
                        if querySnapshot!.documents.count == 1 && self.me!.userName! == self.nickName.text{
                            
                            self.fireStoreDatabase.collection("Members").document(self.uid).setData(firestoreMember, merge: true, completion:
                            { error in
                                if error != nil
                                {
                                    LoadingView.instance.removeView()
                                    LoadingView.instance.loading = false
                                    self.alert(title: "Error", message: error?.localizedDescription ?? "Err")
                                }
                                else
                                {
                                    self.SetImageAndGetUrl()
                                }
                            })
                        }
                        else if querySnapshot!.documents.count == 0{
                            
                            self.fireStoreDatabase.collection("Members").document(self.uid).setData(firestoreMember, merge: true, completion:
                            { error in
                                if error != nil
                                {
                                    LoadingView.instance.removeView()
                                    LoadingView.instance.loading = false
                                    self.alert(title: "Error", message: error?.localizedDescription ?? "Err")
                                }
                                else
                                {
                                    
                                        
                                    self.SetImageAndGetUrl()
                                    
                                    
                                    
                                    
                                }
                            })
                        }
                        else{
                            LoadingView.instance.removeView()
                            LoadingView.instance.loading = false
                            self.alert(title: "Uyarı", message: "Bu kullanıcı adı daha önce alındı.Lütfen farklı bir kullanıcı adı seçin!!")
                        }
                        
                    }
                    else {
                        LoadingView.instance.removeView()
                        LoadingView.instance.loading = false
                        self.alert(title: "Uyarı", message: "Bu kullanıcı adı daha önce alındı.Lütfen farklı bir kullanıcı adı seçin!!")
                    }
                }
            }
            
            
        }
        else{
            LoadingView.instance.removeView()
            LoadingView.instance.loading = false
            alert(title: "Uyarı", message: "Lütfen gerekli alanları doldurduğunuzdan ve seçim gerektiren alanların dolu olduğundan emin olun")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InformationToFeed"{
            
            if updateOrRegister == 0{
            }
            if updateOrRegister == 1{
                let tabBar = segue.destination as! UITabBarController
                tabBar.selectedIndex = 4
            }
        }
    }
}

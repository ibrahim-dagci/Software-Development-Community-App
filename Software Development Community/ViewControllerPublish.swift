//
//  ViewControllerPublish.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 11.03.2023.
//

import UIKit

class ViewControllerPublish: UIViewController {
    var controlPublishType:Bool?
    @IBOutlet weak var datePickerField: UITextField!
    private var pickControl = false
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    var datePicker:UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        designInitialize()
        imageClickMaterials()
        let touchSensor = UITapGestureRecognizer(target: self, action: #selector(self.touchTheFreeArea))
        view.addGestureRecognizer(touchSensor)
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChange(datePicker:)), for: .valueChanged)
        datePicker?.preferredDatePickerStyle = .wheels
        datePickerField.inputView = datePicker
        
    }
    @objc  func dateChange(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        datePickerField.text = date
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        chooseImage()
    }
    @IBAction func publishButtonClicked(_ sender: Any) {
        if let control = controlPublishType{
            if control == true{
                if datePickerField.text != nil && pickControl == true{
                    let data = ["date":datePickerField.text,"comment":commentText.text] as [String:Any]
                    setDataToFirestore(collection: "Gallery", data: data, storageChild: "gallery").setPublish(dataImage: postImage.image!, urlName: "galleryPhotoUrl")
                    navigationController?.popViewController(animated: true)
                    
                }
                else{
                    alert(title: "Uyarı", message: "Lütfen resim ve tarih seçtiğinizden emin olun. Açıklama yazmak zorunlu değildir.")
                }
            }else{
               
            }
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
    
    func designInitialize(){
        //design initialize______________________________________________________________
        self.navigationItem.hidesBackButton = false
        commentText.layer.borderWidth = 1
        commentText.layer.cornerRadius = 10
        commentText.layer.borderColor = UIColor.lightGray.cgColor
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if let control = controlPublishType{
            if control == true{
                self.navigationItem.title = "FOTOĞRAF YAYINLA"
                publishButton.setTitle("FOTOĞRAF YAYINLA", for: .normal)
                postImage.image = UIImage(systemName: "person.2.crop.square.stack")
            }else{
                self.navigationItem.title = "DUYURU YAYINLA"
                publishButton.setTitle("DUYURU YAYINLA", for: .normal)
                postImage.image = UIImage(systemName: "info")
            }
        }
    
    }

}
extension ViewControllerPublish :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    
    @objc func touchTheFreeArea(){
        view.endEditing(true)
        
    }
    //galleri chooose image funcs --------
    func imageClickMaterials(){
      postImage.isUserInteractionEnabled = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage) )
        postImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        pickerControler.sourceType = .photoLibrary
        present(pickerControler, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        pickControl = true
        self.dismiss(animated: true, completion: nil)
    }
    //------------------------------------------
}

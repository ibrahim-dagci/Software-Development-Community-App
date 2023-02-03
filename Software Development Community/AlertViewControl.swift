//
//  AlertViewControl.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 25.09.2022.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commoInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commoInit(){
        img.layer.cornerRadius = 30
        img.layer.borderColor = UIColor.blue.cgColor
        img.layer.borderWidth = 3
        alertView.layer.cornerRadius = 8
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    func showAlert(message:String,alertImageName:String,header:String){
        img.image = UIImage(named: alertImageName)
        self.messageLabel.text = message
        self.header.text = header
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func okeyButtonClick(_ sender: UIButton) {
        parentView.removeFromSuperview()
    }
}


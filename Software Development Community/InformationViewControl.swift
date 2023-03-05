//
//  InformationViewControl.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 19.02.2023.
//

import Foundation
import UIKit

class InformationView : UIView {
    @IBOutlet weak var parentView: UIView!
    
    static let instance = InformationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("InformationView", owner: self, options: nil)
        commoInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commoInit(){
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    func showInfo(){
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }

    
}

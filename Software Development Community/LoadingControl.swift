//
//  LoadingControl.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 26.09.2022.
//

import Foundation
import UIKit
class LoadingView : UIView {
    
    static let instance = LoadingView()
    
   
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var cyanView: UIView!
    @IBOutlet weak var orangeView: UIView!
    lazy var circles:[UIView] = [redView,blueView,orangeView,cyanView]
    var circle = 0
    var colors : [UIColor] = [.red,.blue,.orange,.cyan]
    lazy var random = Int.random(in: 0...colors.count-1)
    var loading = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        commoInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commoInit(){
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpCircle()
    }
    func showLoading(){
        UIApplication.shared.keyWindow?.addSubview(self.parentView)
        loading = true
        loadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(40)) {
            self.parentView.removeFromSuperview()
            self.loading = false
            self.loadingView()
        }
        
    }
    
    func setUpCircle(){
        circles.forEach { circle in
            circle.layer.cornerRadius = circle.frame.height / 2
            circle.backgroundColor = .clear
            circle.isUserInteractionEnabled = false
        }
    }
    
    func nextCircle(){
        random = Int.random(in: 0...colors.count-1)
        if circle == colors.count-1 {
            circle = 0
        }
        else{
            circle = circle + 1
        }
    }
    
    func circleAnimation(){
        circles[circle].backgroundColor = colors[random].withAlphaComponent(0)
        UIView.animate(withDuration: 0.50) {
            self.circles[self.circle].backgroundColor = self.colors[self.random].withAlphaComponent(0.70)
        } completion: { succes in
            self.colors[self.random].withAlphaComponent(0)
            self.nextCircle()
            if self.loading == true {
                self.circleAnimation()
            }
            
        }
    }
    
    func loadingView(){
        if loading == true {
            circleAnimation()
        }
        else{
            setUpCircle()
            
        }
    }
    
    func removeView(){
        parentView.removeFromSuperview()
    }
}

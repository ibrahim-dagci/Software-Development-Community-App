//
//  ViewControllerGlleryImage.swift
//  Software Development Community
//
//  Created by ibrahim dağcı on 16.04.2023.
//

import UIKit

class ViewControllerGalleryImage: UIViewController, UIScrollViewDelegate {

    var selectedIndex: Int = 0
    var imageArray = [UIImageView]()
    var imageCommentArray = [String]()
    var imageDateArray = [String]()
    fileprivate let scrollView : UIScrollView = {
       let sv = UIScrollView()
        sv.contentMode = .scaleAspectFit
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = true
        sv.backgroundColor = .black
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 6
        return sv
    }()
    
    fileprivate let imageV : UIImageView = {
       let iv  = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds  = true
        return iv
    }()
    
    fileprivate let exitButton:UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(exitClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        setupGesture()
        loadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    func setupView(){
        super.viewDidLoad()
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imageV)
        view.addSubview(commentLabel)
        view.addSubview(exitButton)
    }
    func setupConstraints(){
        scrollView.frame = view.bounds
        imageV.frame = scrollView.bounds
        commentLabel.frame = CGRect(x:20,y: view.frame.height-50, width:view.frame.width-40,height: 21)
        exitButton.frame = CGRect(x:20,y: (self.navigationController?.navigationBar.frame.size.height)!, width:25,height: 25)
    }
    
    func setupGesture(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapOnScrollView(recognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        let lefttSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:)))
        rightSwipe.direction = .right
        lefttSwipe.direction = .left
        scrollView.addGestureRecognizer(rightSwipe)
        scrollView.addGestureRecognizer(lefttSwipe)
    }
    
    func loadImage(){
        imageV.image = imageArray[selectedIndex].image
        commentLabel.text = "\(imageCommentArray[selectedIndex])～\(imageDateArray[selectedIndex])"
    }
    
    @objc func exitClicked(){
        dismissView()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleSwipeFrom(recognizer:UISwipeGestureRecognizer){
        let direction:UISwipeGestureRecognizer.Direction = recognizer.direction
        switch direction{
        case UISwipeGestureRecognizer.Direction.right:
            self.selectedIndex -= 1
        case UISwipeGestureRecognizer.Direction.left:
            self.selectedIndex += 1
        default:
            break
        }
        self.selectedIndex = (self.selectedIndex < 0) ? (imageArray.count-1):(self.selectedIndex % self.imageArray.count)
        loadImage()
    }
    
    
    @objc func handleDoubleTapOnScrollView(recognizer:UITapGestureRecognizer){
        if scrollView.zoomScale == 1{
            scrollView.zoom(to: scaleForZoom(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            exitButton.isHidden = true
            commentLabel.isHidden = true
        }
        else{
            scrollView.setZoomScale(1, animated: true)
            exitButton.isHidden = false
            commentLabel.isHidden = false
        }
    }
    @objc func handleSingleTapOnScrollView(recognizer:UITapGestureRecognizer){
        if exitButton.isHidden{
            exitButton.isHidden = false
            commentLabel.isHidden = false
        }
        else{
            exitButton.isHidden = true
            commentLabel.isHidden = true
        }
    }

    func scaleForZoom(scale:CGFloat,center:CGPoint) -> CGRect{
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageV.frame.size.height / scale
        zoomRect.size.width = imageV.frame.size.width / scale
        
        let newCenter = imageV.convert(center,from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1{
            if let image = imageV.image{
                let ratioW = imageV.frame.width / image.size.width
                let ratioH = imageV.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW:ratioH
                let newWidth = image.size.width * ratio
                let newHeigth = image.size.height * ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageV.frame.width ? (newWidth - imageV.frame.width):(scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeigth * scrollView.zoomScale > imageV.frame.height ? (newHeigth - imageV.frame.height):(scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        }
        else{
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}

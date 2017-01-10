//
//  SBPresentationMainVC.swift
//  Preso
//
//  Created by Ricky Roy on 1/9/17.
//  Copyright © 2017 Snowbourne LLC. All rights reserved.
//

import UIKit

class SBPresentationMainCell: UICollectionViewCell {
    
    func setImage(img: UIImage) {
        //TODO
    }
}

class SBPresentationMainVC: UIViewController {
    
    var presentationVC: SBPresentationVC!
    var currentPage: Int = -1
    var externalWindow: UIWindow?
    var renderer: SBImgRenderPdf!
    
    static let tabWidthDimension = 70
    
    var flowLayout: UICollectionViewFlowLayout!
    var laserPointer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
    var xGap: CGFloat = 0
    var yGap: CGFloat = 0
    var pageAscending = false
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaserPointerView()
        setupGestureRecognizers()
        NotificationCenter.default.addObserver(self, selector: #selector(imageReadyNotification(notification:)), name: Notification.Name.Preso.ImageReady, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Configuration Methods
    
    func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(recognizer:)))
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(imageViewSwipeBack(recognizer:)))
        let swipeForward = UISwipeGestureRecognizer(target: self, action: #selector(imageViewSwipeForward(recognizer:)))
        swipeBack.direction = .right
        swipeForward.direction = .left
        mainImageView.gestureRecognizers = [tap,swipeForward,swipeBack]
    }
    
    func configureLaserPointerView() {
        laserPointer.backgroundColor = UIColor.red
        laserPointer.layer.cornerRadius = laserPointer.frame.size.width / 2
        laserPointer.layer.borderColor = UIColor.white.cgColor
        laserPointer.layer.borderWidth = 4
        if laserPointer.superview == nil {
            view.addSubview(laserPointer)
        }
    }

    // MARK: Presentation Action Methods
    
    func updateContent() {
        animatePageChange()
    }
    
    func animatePageChange() {
        var transition: UIViewAnimationOptions!
        switch presentationVC.slideTransitionStyle {
        case .Fade:
            transition = UIViewAnimationOptions.transitionCrossDissolve
        case .FlipLeftRight:
            transition = pageAscending ? UIViewAnimationOptions.transitionFlipFromRight : UIViewAnimationOptions.transitionFlipFromLeft
        case .FlipTopBottom:
            transition = pageAscending ? UIViewAnimationOptions.transitionFlipFromTop : UIViewAnimationOptions.transitionFlipFromBottom
        case .Page:
            transition = pageAscending ? UIViewAnimationOptions.transitionCurlUp : UIViewAnimationOptions.transitionCurlDown
        case .None:
            break
        }
        let toImage = renderer.imageForPage(type: .Full, page: currentPage)
        UIView.transition(with: mainImageView, duration: mainImageAnimationTranstionDuration, options: transition, animations: {
            self.mainImageView.image = toImage
        }, completion: nil)
    }
    
    func setCurrentPage(page: Int) {
        if page < 0 {
            mainImageView.image = nil
        } else if page != currentPage {
            pageAscending = currentPage > page ? false : true
            currentPage = page
            animatePageChange()
        }
        if laserPointer.superview != nil {
            hideLaserPointer()
        }
    }
    
    // MARK: Laser Pointer Methods
    
    func prepareLaserPointer(width: CGFloat, height: CGFloat) {
        
    }
    
    func moveLaserPointer(xPercent: CGFloat, yPercent: CGFloat) {
        
    }
    
    func hideLaserPointer() {
        laserPointer.removeFromSuperview()
    }
    // MARK: Notifications
    
    func imageReadyNotification(notification: NSNotification) {
        if let obj = notification.object as? NSNumber {
            let index = obj.intValue
            if index == currentPage {
                mainImageView.image = renderer.imageForPage(type: .Full, page: currentPage)
            }
        }
    }
    
    // MARK: Gesture Recognizers
    func imageViewSwipeBack(recognizer: UISwipeGestureRecognizer) {
        
    }
    func imageViewSwipeForward(recognizer: UISwipeGestureRecognizer) {
        
    }
    func imageViewTapped(recognizer: UITapGestureRecognizer) {
        
    }

}

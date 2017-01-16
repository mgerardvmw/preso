//
//  SBSliderCell.swift
//  Preso
//
//  Created by Ricky Roy on 1/15/17.
//  Copyright © 2017 Snowbourne LLC. All rights reserved.
//

import UIKit

class SBSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var slideTimerLabel: UILabel!
    
    private var renderer: SBImgRenderPdf!
    
    private var currentPage: Int = 0
    private var activePage: Int = 0
    private var showLargePreview = false
    private var parentVC: SBPresentationSliderVC!
    private var cellIsActive = false
    private var widthRatio: CGFloat = 0.0
    private var startWidth: CGFloat = 0.0
    private var startHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinnerView.isHidden = true
        spinnerView.stopAnimating()
        subscribeToNotifications()
    }
    
    func setRenderer(rend: SBImgRenderPdf) {
        renderer = rend
        
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(sliderDidScroll(notification:)), name: Notification.Name.Preso.SliderDidScroll, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(imageReadyNotification(notification:)), name: Notification.Name.Preso.ImageReady, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(largePreviewMode(notification:)), name: Notification.Name.Preso.ResizeCellsForLargePreviewMode, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(releaseImagesOnBackground(notification:)), name: Notification.Name.Preso.ShouldReleaseImagesOnBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadImagesOnForeground(notification:)), name: Notification.Name.Preso.ShouldReloadImagesOnForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(activePageDidChange(notification:)), name: Notification.Name.Preso.ActivePageDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(slideTimerUpdate(notification:)), name: Notification.Name.Preso.SlideTimerUpdate, object: nil)
    }
    
    func setActivePage(active: Int) {
        activePage = active
        setCellIsActive(active: activePage == currentPage)
    }
    
    func setCellIsActive(active: Bool) {
        cellIsActive = active
        timerView.backgroundColor = active ? UIColor.white : UIColor.clear
        if cellIsActive == false {
            slideTimerLabel.text = ""
        }
    }
    
    func setImage(img: UIImage?) {
        guard let image = img  else {
            spinnerView.isHidden = false
            spinnerView.startAnimating()
            imageView.image = nil
            return
        }
        spinnerView.isHidden = true
        spinnerView.stopAnimating()
        widthRatio = image.size.width / image.size.height
        if widthRatio >= 1 {
            startWidth = frame.size.width
            startHeight = frame.size.width / widthRatio
        } else {
            startHeight = frame.size.width
            startWidth = frame.size.width / widthRatio
        }
        imageWidthConstraint.constant = startWidth
        imageHeightConstraint.constant = startHeight
        imageView.image = image
    }
    
    func setCurrentPage(page: Int) {
        if currentPage != page {
            currentPage = page
            setImage(img: renderer.imageForPage(type: .Thumbnail, page: currentPage))
        }
        pageNumberLabel.text = String(currentPage + 1)
    }
    
    //MARK: Notification methods
    
    func sliderDidScroll(notification: Notification) {
        guard let num = notification.object as? NSNumber else {
            return
        }
        let center = CGFloat(num.floatValue)
        let x = frame.origin.x + frame.size.width / 2
        var ratio = (1.2 - abs(x - center) / 200)
        if ratio < 0.8 {
            ratio = 0.8
        }
        imageWidthConstraint.constant = startWidth * ratio
        imageHeightConstraint.constant = startHeight * ratio
        
    }
    
    func imageReadyNotification(notification: Notification) {
        if imageView.image == nil && notification.object == nil && currentPage > 0 {
            setImage(img: renderer.imageForPage(type: .Thumbnail, page: currentPage))
        } else {
            guard let num = notification.object as? NSNumber else {
                return
            }
            let index = num.intValue
            if index == currentPage {
                currentPage = -1
                setCurrentPage(page: index)
            }
        }
    }
    
    func largePreviewMode(notification: Notification) {
        imageHeightConstraint.constant = startHeight
        imageWidthConstraint.constant = startWidth
    }
    
    func releaseImagesOnBackground(notification: Notification) {
        imageView.image = nil
    }
    
    func reloadImagesOnForeground(notification: Notification) {
        imageView.image = renderer.imageForPage(type: .Thumbnail, page: currentPage)
    }
    
    func activePageDidChange(notification: Notification) {
        if let pageNum = notification.object as? NSNumber {
            let page = pageNum.intValue
            setActivePage(active: page)
        }
    }
    
    func slideTimerUpdate(notification: Notification) {
        guard let str = notification.object as? String else {
            slideTimerLabel.text = ""
            return
        }
        if currentPage == activePage {
            slideTimerLabel.text = str
            timerView.isHidden = false
        } else {
            timerView.isHidden = true
        }
    }
}










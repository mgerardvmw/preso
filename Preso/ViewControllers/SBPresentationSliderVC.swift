//
//  SBPresentationSliderVC.swift
//  Preso
//
//  Created by Ricky Roy on 1/9/17.
//  Copyright © 2017 Snowbourne LLC. All rights reserved.
//

import UIKit

class SBPresentationSliderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var presentationVC: SBPresentationVC!
    var showLargePreview = false
    var flowLayout: UICollectionViewFlowLayout!
    var currentPage: Int = -1
    var renderer: SBImgRenderPdf!
    
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderBGViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderBGView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 0
        sliderBGView.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupCollectionView() {
        if flowLayout == nil {
            flowLayout = UICollectionViewFlowLayout()
        }
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.scrollDirection = showLargePreview ? .vertical : .horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sliderCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sliderCollectionView.delegate = self
        sliderCollectionView.showsVerticalScrollIndicator = false
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.isPagingEnabled = false
        sliderCollectionView.collectionViewLayout = flowLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        if section == 0 || section == 2 {
            items = showLargePreview ? 0 : 1
        } else if section == 1 {
            items = presentationVC.numberOfPages
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = isIpad ? sliderHeightStandardIpad : sliderHeightStandard
        var width = height - 30
        if indexPath.section == 0 || indexPath.section == 2 {
            width = sliderCollectionView.frame.size.width / 2 - sliderCollectionView.frame.size.height / 2
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: SBSliderCell! = nil
        if indexPath.section == 0 || indexPath.section == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeholderCell", for: indexPath) as! SBSliderCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SBSliderCell
            if cell.parentView == nil {
                cell.parentView = self
                cell.renderer = renderer
            }
            cell.showLargePreview = showLargePreview
            cell.currentPage = indexPath.row
            cell.activePage = currentPage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            presentationVC.ju
            currentPage = indexPath.row
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if showLargePreview == false {
            let center = scrollView.contentOffset.x + scrollView.frame.size.width / 2
            NotificationCenter.default.post(name: Notification.Name.Preso.SliderDidScroll, object: center)
        }
    }
    
    
    

}

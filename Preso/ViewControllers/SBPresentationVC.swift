//
//  SBPresentationVC.swift
//  Preso
//
//  Created by Ricky Roy on 1/9/17.
//  Copyright © 2017 Snowbourne LLC. All rights reserved.
//

import UIKit

class SBPresentationVC: UIViewController {
    
    var slideTransitionStyle: SBPresentationTransitionStyle = .Fade
    
    var filePath: NSString!
    var numberOfPages: Int = 0
    var currentPage: Int = 0
    var controlsAreVisible = true
    var state = SBPresentationModeState.Finished
    
    private var viewIsConfigured = false
    private var sliderVC: SBPresentationSliderVC!
    private var mainVC: SBPresentationMainVC!
    private var currentOrientation: UIInterfaceOrientation!
    
    private var activeImage: UIImage!
//    private var activeImageData: Data!
    private var displaysItem: UIBarButtonItem!
    private var largePreviewItem: UIBarButtonItem!
    private var showLargePreview = false
    private var lastRenderedPage = -1
    
    // external display variables
    private var externalWindow: UIWindow?
    private var externalDisplay: UIScreen?
    private var externalScreenMode: UIScreenMode?
    private var availableExternalScreenModes: [UIScreenMode] = []
    private var startTime: CFTimeInterval!
    private var slideStartTime: CFTimeInterval!
    private var currentTime: CFTimeInterval!
    private var timeForPresentation: CFTimeInterval!
    private var timeForSlide: CFTimeInterval!
    private var timerState: SBPresentationTimerState = .Stopped
    private var mainTimer: Timer!
    private var renderer: SBImgRenderPdf!
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Bar Button Methods
    
    func backButtonPressed() {
        renderer.state = .UserCancelled
        state = .UserCancelled
        dismissPresentationMode()
    }
    
    func dismissPresentationMode() {
        if mainTimer != nil {
            mainTimer.invalidate()
            mainTimer = nil
        }
        mainVC.currentPage = -1
        renderer.clearSlideImagesFromDisk()
        dismiss(animated: true, completion: nil)
    }
    
    
}

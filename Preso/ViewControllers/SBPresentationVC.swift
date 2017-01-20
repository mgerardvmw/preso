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
    
    func timerButton() {
        if timerState == .Stopped {
            timerState = .Running
        } else if timerState == .Running {
            timerState = .Paused
        } else if timerState == .Paused {
            let title = NSLocalizedString("Timer Settings", comment: "Timer Settings")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let resetAction = UIAlertAction(title: NSLocalizedString("Reset Timer", comment: "Reset Timer"), style: .default, handler: { (UIAlertAction) in
                self.timerState = .Stopped
            })
            let resumeAction = UIAlertAction(title: NSLocalizedString("Resume", comment: "resume"), style: .default, handler: { (UIAlertAction) in
                self.timerState = .Running
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (UIAlertAction) in
                //
            })
            alert.addAction(resetAction)
            alert.addAction(resumeAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setTimerState(state: SBPresentationTimerState) {
        if state == timerState {
            return
        }
        if state == .Running {
            if timerState == .Stopped || timerState == .Paused {
                currentTime = CACurrentMediaTime()
                startTime = CACurrentMediaTime()
                slideStartTime = CACurrentMediaTime()
            }
//            timersubbutton? //TODO
            mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerFired), userInfo: nil, repeats: true)
        } else if state == .Paused || state == .Stopped {
            mainTimer.invalidate()
            mainTimer = nil
            //timerSubBUtton icon change //TODO
            if state == .Stopped {
//                timersublabel  = "" //TODO 
                NotificationCenter.default.post(name: Notification.Name.Preso.SlideTimerUpdate, object: "0:00")
                timeForSlide = 0
                timeForPresentation = 0
            }
        }
        timerState = state
    }
    
    func mainTimerFired() {
        currentTime = CACurrentMediaTime()
        timeForPresentation = timeForPresentation + currentTime - startTime
        var minutes = Int(timeForPresentation / 60.0)
        var secs = Int(timeForPresentation - CFTimeInterval(minutes) * 60)
        timeForSlide = timeForSlide + currentTime - slideStartTime
        minutes = Int(timeForSlide) / 60
        secs = Int(timeForSlide) - minutes * 60
        slideStartTime = currentTime
        startTime = currentTime
        let str = String(minutes) + ":" + String(format: "%02d", secs)
        NotificationCenter.default.post(name: Notification.Name.Preso.SlideTimerUpdate, object: str)
    }
    
    func detectExternalScreens() {
        if UIScreen.screens.count > 1 {
            //we have an ext screen!
            externalDisplay = UIScreen.screens[1]
            if let modes = externalDisplay?.availableModes {
                availableExternalScreenModes = modes
            }
            
            
        }
    }
    
}

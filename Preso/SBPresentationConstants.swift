//
//  SBPresentationConstants.swift
//  Preso
//
//  Created by Ricky Roy on 12/30/16.
//  Copyright © 2016 Snowbourne LLC. All rights reserved.
//

import Foundation
import UIKit

let kGoogleCastReceiverAppID = "36ED3C8F"
let kGoogleCastDebugLoggingEnabled = true

enum SBPresentationTransitionStyle {
    case Fade
    case FlipLeftRight
    case FlipTopBottom
    case Page
    case None
}

enum SBPresentationModeState {
    case Finished
    case RenderInProgress
    case Suspended
    case UserCancelled
}

enum SBPresentationTimerState {
    case Stopped
    case Running
    case Paused
}

enum SBPresentationImageType {
    case Full
    case Thumbnail
    case Watch
}

extension Notification.Name {
    enum Preso
    {
        static let ActivePageDidChange = Notification.Name(rawValue: "SBnotifyActivePageDidChange")
        static let ShouldReleaseImagesOnBackground = Notification.Name(rawValue: "SBnotifyShouldReleaseImagesOnBackground")
        static let ShouldReloadImagesOnForeground = Notification.Name(rawValue: "SBnotifyShouldReloadImagesOnForeground")
        static let ImageReady = Notification.Name(rawValue: "SBnotifyImageReadyNotification")
        static let SlideTimerUpdate = Notification.Name(rawValue: "SBnotifySlideTimerUpdate")
        static let ResizeCellsForLargePreviewMode = Notification.Name(rawValue: "notifyResizeCellsForLargePreviewMode")
        static let SliderDidScroll = Notification.Name(rawValue: "sliderDidScroll")
    }
}


let presentationsBaseFilePath = "slidesTemp"
let sliderHeightStandard: CGFloat = 130
let sliderHeightStandardIpad: CGFloat = 160
let watchThumbnailSize: Float = 150
let cellSpacing: CGFloat = 3.0
let mainImageAnimationTranstionDuration: Double = 0.6
let isIpad = UIDevice.current.userInterfaceIdiom == .pad

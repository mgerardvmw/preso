//
//  SBPresentationConstants.swift
//  Preso
//
//  Created by Ricky Roy on 12/30/16.
//  Copyright © 2016 Snowbourne LLC. All rights reserved.
//

import Foundation



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
    }
}


let presentationsBaseFilePath = "slidesTemp"
let sliderHeightStandard: Float = 130
let sliderHeightStandardIpad: Float = 160
let watchThumbnailSize: Float = 150
let cellSpacing: Float = 3
let mainImageAnimationTranstionDuration: Double = 0.6

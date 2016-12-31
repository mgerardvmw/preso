//
//  SBImgRenderPdf.swift
//  Preso
//
//  Created by Ricky Roy on 12/30/16.
//  Copyright © 2016 Snowbourne LLC. All rights reserved.
//

import UIKit

protocol SBPresentationImageRenderDelegate {
    func dismissPresentationView()
    func updateNumberOfPages(numPages: NSInteger)
}

class SBImgRenderPdf: NSObject {
    
    var appleWatchEnabled = false
    var delegate: SBPresentationImageRenderDelegate?
    var filePath: URL?
    
    var state: SBPresentationModeState = SBPresentationModeState.Suspended
    var numberOfPages = 0
    var currentPage = 0
    var lastRenderedPage = 0
    
    //private variables
    private var activeImage: UIImage?
    private var activeImageData: Data?
    private var pdf: CGPDFDocument!
    private var provider: CGDataProvider!
    private var fileData: Data?
    
    init(path: URL) {
        self.filePath = path
    }
    
    init(data: Data) {
        self.fileData = data
    }
    
    func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    func appDidEnterBackground() {
        state = .Suspended
        NotificationCenter.default.post(name: Notification.Name.Preso.ShouldReleaseImagesOnBackground, object: nil)
    }
    
    func appWillEnterForeground() {
        if lastRenderedPage < numberOfPages {
            state = .RenderInProgress
        } else {
            state = .Finished
        }
        NotificationCenter.default.post(name: Notification.Name.Preso.ShouldReloadImagesOnForeground, object: nil)
    }
    
    func openPDFContext() {
        guard let filePath = filePath else {
            numberOfPages = 0
            lastRenderedPage = 0
            return
        }
        state = .RenderInProgress
        if fileData == nil {
            do {
                try fileData = Data.init(contentsOf: filePath)
            } catch let error as Error {
                //TODO log error
                return
            }
        }
        let myPDFData: CFData = fileData as! CFData
        guard let dataProvider = CGDataProvider(data: myPDFData) else {
            return
        }
        provider = dataProvider
        pdf = CGPDFDocument(provider)
        numberOfPages = pdf.numberOfPages
        DispatchQueue.main.sync {
            guard let _ = delegate?.updateNumberOfPages(numPages: numberOfPages) else {
                // delegate hasn't implemented this selector
                return
            }
        }
    }
    
    func closePDFContext() {
        if fileData != nil {
            fileData = nil
            activeImage = nil
            activeImageData = nil
            pdf = nil
            provider = nil
            state = .Finished
        }
    }
    
    func createPresentationPages() {
        if filePath == nil && fileData == nil {
            return
        }
        
        var filename: String?
        var thumbnailName: String?
        var microThumbnailName: String?
        var page: CGPDFPage?
        lastRenderedPage += 1
        
        if lastRenderedPage > numberOfPages {
            return
        }
        
        for i in lastRenderedPage ..< numberOfPages {
            if state == .UserCancelled {
                DispatchQueue.main.sync {
                    closePDFContext()
                    delegate?.dismissPresentationView()
                }
                return
            } else if state == .Suspended {
                lastRenderedPage -= 1
                DispatchQueue.main.sync {
                    NotificationCenter.default.post(name: Notification.Name.Preso.ShouldReleaseImagesOnBackground, object: nil)
                }
                return
            }
            
            autoreleasepool {
                filename = "page" + String(i - 1) + ".jpg"
                thumbnailName = "thumb" + String(i - 1) + ".jpg"
                page = pdf.page(at: i)
//                activeImage = 
                
            }
            
        }
    }
    
    func createImageForPage(page: CGPDFPage, pageNum: Int) -> UIImage? {
        let rect = page.getBoxRect(.cropBox)
        let scale = 1080 / rect.size.height
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.ctm.translatedBy(x: 0.0, y: rect.size.height)
        context?.ctm.scaledBy(x: 1.0, y: -1.0)
        context?.fill(rect)
        let transform = page.getDrawingTransform(.cropBox, rect: rect, rotate: 0, preserveAspectRatio: true)
        context?.ctm.concatenating(transform)
        context?.drawPDFPage(page)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return image
    }
    
    func thumbnailImageForType(type: SBPresentationImageType,image: UIImage) -> UIImage? {
        let width = Float(image.size.width)
        let height = Float(image.size.height)
        var ratio = 1.0
        let screenScale = UIScreen.main.scale
        var maxDim: Float = 0.0
        var varScale: CGFloat = 1.0
        if type == .Thumbnail {
            maxDim = UIDevice.current.userInterfaceIdiom == .pad ? sliderHeightStandardIpad : sliderHeightStandard
        } else if type == .Watch {
            maxDim = watchThumbnailSize
            varScale = 0.0
        }
        maxDim = maxDim * Float(screenScale)
        if width > maxDim && height > maxDim {
            if width > height {
                ratio = Double(maxDim / width)
            } else {
                ratio = Double(maxDim / height)
            }
        }
        let newSize = CGSize(width: Double(width) * ratio, height: Double(height) * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, varScale)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageForPage(type: SBPresentationImageType, page: Int) -> UIImage? {
        var filename: String!
        if type == .Full { filename = "page" + String(page) + ".jpg" }
        else if type == .Thumbnail { filename = "thumb" + String(page) + ".jpg" }
        else if type == .Watch { filename = "watch" + String(page) + ".jpg" }
        
        var path = baseFilePath()
        path = path.appendingPathComponent(filename)
        guard let data = FileManager.default.contents(atPath: path.absoluteString) else {
            return nil
        }
        let image = UIImage(data: data)
        return image
    }
    
    func baseFilePath() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let basePath = paths.first
        var path = URL(fileURLWithPath: basePath!)
        path = path.appendingPathComponent(presentationsBaseFilePath)
        return path
    }
    
    func clearSlideImagesFromDisk() {
        let fm = FileManager.default
        do {
            let files = try fm.contentsOfDirectory(at: baseFilePath(), includingPropertiesForKeys: [], options: [])
            for file in files {
                let path = baseFilePath().appendingPathComponent(file.absoluteString, isDirectory: false)
                do {
                    try fm.removeItem(at: path)
                } catch let error as Error {
                    //error deleting files
                }
            }
        } catch let error as Error {
            //error listing files
            return
        }
    }
}















































//
//  ProjectCameraController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/28/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit
import AVFoundation

class ProjectCameraController: UIViewController, PhotoSelectorDelegate {
    
    struct AlphaAnimation {
        init(alpha: CGFloat, _ duration: Double) {
            self.alpha = alpha
            self.duration = duration
        }
        
        var alpha: CGFloat = 0
        var duration: Double = 0
    }

    var viewFinderHeight: CGFloat = 0.0
    var viewFinderWidth: CGFloat = 0.0
    var viewFinderMarginTop: CGFloat = 0.0
    var viewFinderMarginLeft: CGFloat = -14.0
    
    var minZoom: Float = 1.0
    var maxZoom: Float = 10.0
    
    var modal: PhotoModalController?
    var minISO: Float = 100
    var maxISO: Float = 100
    var currentISO: Float = 100
    
    var currentFocus: Float = 0.0
    var minFocus: Float = 0.0
    var maxFocus: Float = 1.0

    var currentAlpha: CGFloat = 1
    var iconAlphaLocked = false
    
    var photos = [UIImage]()
    var selectedPhotoIndex: Int = 0

    var alphaAnimationQueue = [AlphaAnimation]()
    
    var device: AVCaptureDevice?
    var session: AVCaptureSession?
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var aspectRatio: CGFloat = 1.0
    var controllerResultsDelegate: ControllerResultsDelegate?

    let stillImageOutput = AVCaptureStillImageOutput()

    @IBOutlet weak var exposureIcon: UIImageView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var captureArea: UIView!
    @IBOutlet weak var takenPhoto: UIImageView!

    @IBAction func showPhoto(sender: UITapGestureRecognizer) {
        if photos.count > 0 {
            if let modal = self.storyboard?.instantiateViewControllerWithIdentifier("projectPhotoInspector") as? PhotoModalController {

                self.modal = modal
                self.modal!.delegate = self
                self.modal!.slides = self.photos
                self.modal!.currentSlideIndex = selectedPhotoIndex
                self.modal!.modalPresentationStyle = .OverCurrentContext
                presentViewController(self.modal!, animated: true, completion: nil)

            }
        }
    }

    @IBAction func doFocusGesture(sender: UIRotationGestureRecognizer) {
        //println("Rotation \(sender.rotation), Velocity: \(sender.velocity)")
        if sender.rotation < 0 {
            focusTo(-0.05)
        } else if sender.rotation > 0 {
            focusTo(+0.05)
        }
    }

    @IBAction func zoomCamera(sender: UISlider) {
        zoomTo(CGFloat(sender.value))
    }

    @IBAction func doZoomGesture(sender: UIPinchGestureRecognizer) {
        //println("Sclae \(sender.scale), Velocity: \(sender.velocity)")
        var currentZoom = Float(zoomSlider.value)
        if sender.velocity > 0 && currentZoom < maxZoom {
            zoomSlider.setValue(currentZoom + 0.1, animated: true)
        } else if sender.velocity < 0 {
            zoomSlider.setValue(currentZoom - 0.1, animated: true)
        }

        zoomCamera(zoomSlider)
    }
    
    @IBAction func doAutofocusGesture(sender: UILongPressGestureRecognizer) {
        autoFocus()
        /*
        switch sender.state {
            case .Began:
                println("Long Press Began")
            case .Ended:
                println("Long Press Ended")
            default:
                println("Long Press Did Something Else")
        }
        */
    }

    @IBAction func doSetISOGesture(sender: UISwipeGestureRecognizer) {
        var location = getLocationPercent(sender.locationInView(captureArea))
 
        switch sender.direction {
            case UISwipeGestureRecognizerDirection.Up:
                println("Swiped Up")
                setISO(50.0)
            case UISwipeGestureRecognizerDirection.Down:
                println("Swiped Down")
                setISO(-50.0)
            case UISwipeGestureRecognizerDirection.Left:
                println("Swiped Left")
            default:
                println("Swiped Right")
        }
        
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        println("Take Photo")
        // we do this on another thread so that we don't hang the UI
        doAsync {
            
            var videoConnection : AVCaptureConnection?
            
            for connection in self.stillImageOutput.connections {
                //find a matching input port
                for port in connection.inputPorts!{
                    
                    if port.mediaType == AVMediaTypeVideo {
                        videoConnection = connection as? AVCaptureConnection
                        break //for port
                    }
                }
                
                if videoConnection  != nil {
                    break// for connections
                }
            }
            
            if videoConnection != nil {
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                    (imageSampleBuffer : CMSampleBuffer!, _) in
                    let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                    
                    let squaredImage = self.squareImage(UIImage(data: imageDataJpeg)!)
                    
                    self.selectedPhotoIndex = self.photos.count
                    self.photos.append(squaredImage)
                    self.takenPhoto.image = self.photos[self.selectedPhotoIndex]
                }
            }
        }

    }

    override func viewDidLoad() {

        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetHigh
        addBackButton()
        authorizeCamera()
        
        if setupDevices() {
            beginSession()
        }
    }
    
    func authorizeCamera() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted: Bool) in
            if !granted {
                doAsync {
                    UIAlertView(
                        title: "Could not use camera!",
                        message: "This application does not have permission to use camera. Please update your privacy settings.",
                        delegate: self,
                        cancelButtonTitle: "OK"
                    ).show()
                }
            }
        }
    }
    
    
    func beginSession() {
        configureDevice()
        
        if let d = device {
            zoomSlider.minimumValue = minZoom
            maxZoom = Float(d.activeFormat.videoMaxZoomFactor)
            zoomSlider.maximumValue = maxZoom > 5 ? 5 : maxZoom
            zoomSlider.setValue(1.0, animated: false)

            // Adjust the iso to clamp between minIso and maxIso based on the active format
            minISO = d.activeFormat.minISO
            maxISO = d.activeFormat.maxISO
        
            setupIO()
        }

        //Set Up Screen


        if screenWidth > screenHeight {
            aspectRatio = screenHeight / screenWidth * aspectRatio
            viewFinderWidth = captureArea.bounds.width
            //viewFinderHeight = captureArea.bounds.height * aspectRatio
            viewFinderMarginTop *= aspectRatio
        } else {
            aspectRatio = screenWidth / screenHeight
            viewFinderWidth = captureArea.bounds.width * aspectRatio
            //viewFinderHeight = captureArea.bounds.height
            viewFinderMarginLeft *= aspectRatio
        }
        
        viewFinderHeight = viewFinderWidth
        
        setupGestureRecognizers()

        var previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureArea.layer.addSublayer(previewLayer)
        previewLayer!.frame = CGRectMake(viewFinderMarginLeft, viewFinderMarginTop, viewFinderWidth, viewFinderHeight)

        session!.startRunning()
    }
    
    
    func configureDevice() {
        if let d = device {
            d.lockForConfiguration(nil)
            d.focusMode = .ContinuousAutoFocus
            d.unlockForConfiguration()
        }
    }
    
    func autoFocus() {
        if let d = device {
            d.lockForConfiguration(nil)
            d.focusMode = .AutoFocus
            d.unlockForConfiguration()
        }
    }

    func zoomTo(factor: CGFloat, rate: Float = 10) {
        if let d = device {
            if d.lockForConfiguration(nil) {
                d.rampToVideoZoomFactor(factor, withRate: rate)
                d.unlockForConfiguration()
            }
        }
    }
    
    func doAlphaAnimation(animation: AlphaAnimation) {
        iconAlphaLocked = true
        UIView.animateWithDuration(animation.duration, animations: { self.exposureIcon.alpha = animation.alpha }) { (Bool) in
            //println("Animation Complete: \(self.minISO) < \(self.currentISO) < \(self.maxISO)")
            if self.alphaAnimationQueue.count > 0 {
                println("Animation Queue: \(self.alphaAnimationQueue.count)")
                self.doAlphaAnimation(self.alphaAnimationQueue.shift())
            } else {
                println("Nothing in Animation Queue")
                UIView.animateWithDuration(0.5, animations: { self.exposureIcon.alpha = 0 }) { (Bool) in
                    self.iconAlphaLocked = false
                    self.alphaAnimationQueue.removeAll(keepCapacity: false)
                }
            }
        }
    }
    
    func setExposureIconAlpha(alpha: CGFloat, duration: Double = 0.2) {
        //println("Set Icon Exposure: \(self.exposureIcon.alpha) - \(alpha)")
        alphaAnimationQueue.append(AlphaAnimation(alpha: alpha, duration))
        
        if !iconAlphaLocked {
            doAlphaAnimation(alphaAnimationQueue.shift())
        }
    }
    
    func setISO(increment: Float) {
        if let d = device {
            if(d.lockForConfiguration(nil)) {
                exposureIcon.hidden = false
                exposureIcon.alpha = self.currentAlpha

                currentISO = (currentISO + increment).clamp(minISO, maxISO)
                self.currentAlpha = CGFloat((currentISO - minISO) / (maxISO - minISO))
                setExposureIconAlpha(self.currentAlpha)
                
                
                d.setExposureModeCustomWithDuration(
                    AVCaptureExposureDurationCurrent, //Shutterspeed parameter--AVCaptureExposureDurationCurrent is the default
                    ISO: currentISO //What amount of light to let into the lens; low ISO: bright, high quality but with a slower shutter speed
                    ) { (time) in
                        //println("UpdateDevice:Set Exposure Mode With custom duration \(time)")
                }
                d.unlockForConfiguration()
            }
        }
    }
    
    func focusTo(increment: Float) {
        if let d = device {
            if(d.lockForConfiguration(nil)) {
                currentFocus = (currentFocus + increment).clamp(minFocus, maxFocus)
                
                d.setFocusModeLockedWithLensPosition(currentFocus) { (time) in
                    //println("UpdateDevice:Set Focus Mode Lucked with Lens Position")
                }
                d.unlockForConfiguration()
            }
        }
    }
    
    func getLocationPercent(location: CGPoint) -> CGPoint {
        var touchPercent = CGPointZero
        touchPercent.x = location.x / screenWidth
        touchPercent.y = location.y / screenHeight
        return touchPercent
    }
    
    func getTouchPercent(touch : UITouch) -> CGPoint {
        return getLocationPercent(touch.locationInView(captureArea))
    }
    
    func squareImage(image: UIImage) -> UIImage {
        var ratio: Double = 0.0
        var delta: Double = 0.0
        var offset = CGPointZero
        var scale: CGFloat = 0.0
        
        var sz = CGSizeMake(viewFinderWidth, viewFinderHeight)
        
        if (image.size.width > image.size.height) {
            ratio = Double(sz.width) / Double(image.size.width)
            delta = ratio * Double(image.size.width) - ratio * Double(image.size.height)
            offset = CGPointMake(CGFloat(delta / 2.0), 0.0)
        } else {
            ratio = Double(sz.height) / Double(image.size.height)
            delta = ratio * Double(image.size.height) - ratio * Double(image.size.width * aspectRatio)
            offset = CGPointMake(0.0, CGFloat(delta / 2));
        }
        
        println("Ratio \(ratio)")
        println("Delta \(delta)")
        println("Offset \(offset)")
        println("Size \(sz)")
        println("Aspect Ration \(aspectRatio)")

        //make the final clipping rect based on the calculated values
        var clipRect = CGRectMake(
            CGFloat(-offset.x),
            CGFloat(-offset.y),
            CGFloat((ratio * Double(image.size.width * aspectRatio)) + delta),
            CGFloat((ratio * Double(image.size.height)) + delta)
        )
        
        //Create Temporary Graphic Context into which scale is drawn
        /*
        UIGraphicsBeginImageContextWithOptions(
            sz, //the size of the resulting image
            true, //whether or not the image is opaque
            scale //set to 0.0 sets to main screen scale
        )
        */
        UIGraphicsBeginImageContext(sz)
        
        image.drawInRect(clipRect)
        
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func photoWasSelected(photo: UIImage?, action: ModalSwipeAction) {
        switch action {
            case .SlideSelected:
                if let delegate = controllerResultsDelegate {
                    navigateBack(photo!)
                    delegate.didCompleteAction(photo!, action: "SelectedPhoto")
                }
            default:
                println("Default Action")
                self.photos = modal!.slides
                
                if self.photos.count > 0 {
                    self.takenPhoto.image = self.photos[0]
                } else {
                    self.takenPhoto.image = UIImage(named: "")
                }
        }
    }
    
    private
    func setupDevices() -> Bool {
 
        let devices = AVCaptureDevice.devices()
        
        for device in devices {

            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    self.device = device as? AVCaptureDevice
                }
            }
        }
        
        
        if self.device != nil {
            return true
        } else {
            return false
        }
        
    }
    
    func setupIO() {
        var err : NSError? = nil

        let deviceInput = AVCaptureDeviceInput(device: device, error: &err)
        if err != nil {
            println("error: \(err?.localizedDescription)")
            abort()
        } else {
            if session!.canAddInput(deviceInput) {
                session!.addInput(deviceInput)
            }
        }
        
        stillImageOutput.outputSettings = [
            AVVideoCodecKey: AVVideoCodecJPEG
        ]
        
        if session!.canAddOutput(stillImageOutput) {
            session!.addOutput(stillImageOutput)
        }
        
        
    }
    
    func setupGestureRecognizers() {
        
        takenPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showPhoto:")))
        
        
        //var rotate = UIRotationGestureRecognizer(target: self, action: Selector("doFocusGesture:"))
        //captureArea.addGestureRecognizer(rotate)

        var pinch = UIPinchGestureRecognizer(target: self, action: Selector("doZoomGesture:"))
        captureArea.addGestureRecognizer(pinch)

        var longTouch = UILongPressGestureRecognizer(target: self, action: Selector("doAutofocusGesture:"))
        captureArea.addGestureRecognizer(longTouch)

        //var tap = UITapGestureRecognizer(target: self, action: Selector("tapArea:"))
        //captureArea.addGestureRecognizer(tap)

        //var swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipeCaptureArea:"))
        //swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        //captureArea.addGestureRecognizer(swipeRight)
        
        //var swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeCaptureArea:"))
        //swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        //captureArea.addGestureRecognizer(swipeLeft)
        
        var swipeTop = UISwipeGestureRecognizer(target: self, action: Selector("doSetISOGesture:"))
        swipeTop.direction = UISwipeGestureRecognizerDirection.Up
        captureArea.addGestureRecognizer(swipeTop)
        
        var swipeBottom = UISwipeGestureRecognizer(target: self, action: Selector("doSetISOGesture:"))
        swipeBottom.direction = UISwipeGestureRecognizerDirection.Down
        captureArea.addGestureRecognizer(swipeBottom)
    }    
}
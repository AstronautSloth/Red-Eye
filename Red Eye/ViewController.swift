//
//  ViewController.swift
//  Red Eye
//
//  Created by Colin Thompson on 3/5/16.
//  Copyright © 2016 Colin Thompson. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        let devices = AVCaptureDevice.devices()
        for device in devices!{
            if (device as AnyObject).hasMediaType(AVMediaTypeVideo){
                if (device as AnyObject).position == AVCaptureDevicePosition.back {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        
        
        
    }
    
    func beginSession() {
        let err : NSError? = nil
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch _ {
            NSLog("error \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.bounds

        previewLayer?.bounds = view.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.zPosition = -1
        
        self.configureDevice()
        
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            }catch _ {
                NSLog("Failed device lock")
            }
            device.focusMode = .continuousAutoFocus
            device.exposureMode = AVCaptureExposureMode.custom
            device.setExposureModeCustomWithDuration(CMTimeMake(1, 10), iso: (captureDevice?.activeFormat.maxISO)!, completionHandler: nil)
            device.flashMode = .off
            device.unlockForConfiguration()
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
        
        var videoConnection : AVCaptureConnection?
        let imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        captureSession.addOutput(imageOutput)
        
        for connection in imageOutput.connections {
            for port in (connection as AnyObject).inputPorts as Array {
                if (port as AnyObject).mediaType == AVMediaTypeVideo {
                    videoConnection = connection as? AVCaptureConnection
                    break
                }
            }
        }

        if self.captureDevice!.hasTorch {
            do {
                try self.captureDevice!.lockForConfiguration()
                self.captureDevice?.torchMode = .on
                self.captureDevice?.flashMode = .off
                self.captureDevice?.exposureMode = AVCaptureExposureMode.custom
                self.captureDevice?.setExposureModeCustomWithDuration(CMTimeMake(1, 10), iso: (captureDevice?.activeFormat.maxISO)!, completionHandler: nil)
                self.captureDevice?.unlockForConfiguration()
            }catch _ {
                NSLog("Error locking device")
            }
        }
        
        
        imageOutput.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            let dataProvider = CGDataProvider(data: imageData as! CFData)
            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
            self.imageView = UIImageView(image: image)
            self.imageView!.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            
            let previewVC = self.storyboard!.instantiateViewController(withIdentifier: "Preview") as! PreviewViewController
            previewVC.toPass = self.imageView.image
        
            
            self.present(previewVC, animated: false, completion: nil)
            
            let seconds = 1.0
            let delay = seconds * Double(NSEC_PER_SEC)
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                do {
                    try self.captureDevice!.lockForConfiguration()
                    self.captureDevice?.torchMode = .off
                    self.captureDevice?.flashMode = .off
                    self.captureDevice?.unlockForConfiguration()
                } catch _ {
                    NSLog("Error locking device")
                }
            })
            
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

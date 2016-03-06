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
        for device in devices{
            if device.hasMediaType(AVMediaTypeVideo){
                if device.position == AVCaptureDevicePosition.Back {
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
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.bounds

        previewLayer.bounds = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.zPosition = -1
        
        
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            }catch _ {
                NSLog("Failed device lock")
            }
            device.focusMode = .ContinuousAutoFocus
            device.flashMode = .On
            device.unlockForConfiguration()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func takePhoto(sender: AnyObject) {
        
        var videoConnection : AVCaptureConnection?
        let imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        captureSession.addOutput(imageOutput)
        
        for connection in imageOutput.connections {
            for port in connection.inputPorts as Array {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection as? AVCaptureConnection
                    break
                }
            }
        }

        
        imageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            let dataProvider = CGDataProviderCreateWithCFData(imageData)
            let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
            let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
            self.imageView = UIImageView(image: image)
            self.imageView!.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            
            
            let previewVC = self.storyboard!.instantiateViewControllerWithIdentifier("Preview") as! PreviewViewController
            previewVC.toPass = self.imageView.image
            self.presentViewController(previewVC, animated: true, completion: nil)
            
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


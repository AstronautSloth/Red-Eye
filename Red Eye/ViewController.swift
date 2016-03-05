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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetLow
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
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            }catch _ {
                NSLog("Failed device lock")
            }
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


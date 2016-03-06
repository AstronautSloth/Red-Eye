//
//  PreviewViewController.swift
//  Red Eye
//
//  Created by Colin Thompson on 3/5/16.
//  Copyright © 2016 Colin Thompson. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var toPass : UIImage!

    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    override func viewDidLoad() {
        //present image, provide option to delete or save, pressing either returns to previous view
        imageView.image = toPass
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
        let cameraVC = self.storyboard?.instantiateViewControllerWithIdentifier("Camera")
        self.presentViewController(cameraVC!, animated: false, completion: nil)
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
        let cameraVC = self.storyboard?.instantiateViewControllerWithIdentifier("Camera")
        self.presentViewController(cameraVC!, animated: false, completion: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
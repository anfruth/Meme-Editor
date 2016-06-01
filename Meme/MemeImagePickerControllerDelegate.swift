//
//  MemeImagePickerControllerDelegate.swift
//  Meme
//
//  Created by Andrew Fruth on 9/10/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        println(info);
    }
}
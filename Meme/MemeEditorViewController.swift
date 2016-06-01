//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Andrew Fruth on 9/9/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageSpaceForMemePic: UIImageView!
    @IBOutlet weak var pickImage: UIBarButtonItem!
    @IBOutlet weak var memeTextTop: UITextField!
    @IBOutlet weak var memeTextBottom: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var savedMeme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        if savedMeme != nil {
            memeTextTop.text = savedMeme.topText
            memeTextTop.font = memeTextTop.font!.fontWithSize(20)
            memeTextBottom.text = savedMeme.bottomText
            memeTextBottom.font = memeTextBottom.font!.fontWithSize(20)
            imageSpaceForMemePic.image = savedMeme.image
            closeWindow(memeTextTop)
            closeWindow(memeTextBottom)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558
    // Thank You!
    
    func keyboardWillShow(notification: NSNotification) {
        if memeTextBottom.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if memeTextBottom.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender.title == "Album" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makeFieldWhite(sender: UITextField) {
        sender.backgroundColor = UIColor.blackColor()
        sender.font = sender.font!.fontWithSize(20)
        sender.borderStyle = UITextBorderStyle.RoundedRect
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        if imageSpaceForMemePic.image != nil {
            let memeImage = generateMemedImage()
            let shareController = UIActivityViewController(activityItems : [memeImage],
                applicationActivities: nil)
            shareController.excludedActivityTypes = []
            
            shareController.completionWithItemsHandler = {(activity, success, items, error) in
                if success == true {
                    self.saveMeme(memeImage)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
            presentViewController(shareController, animated: true, completion: nil)
        } else {
            print("no image to share")
        }
    }
    
    func saveMeme(memeImage: UIImage) {
        let meme = Meme(topText: memeTextTop.text!, bottomText: memeTextBottom.text!, image: imageSpaceForMemePic.image!, memedImage: memeImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    @IBAction func clearMeme() {
        imageSpaceForMemePic.image = nil
        memeTextTop.text = nil
        memeTextBottom.text = nil
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }

    
    @IBAction func closeWindow(sender: UITextField) {
        sender.backgroundColor = UIColor.clearColor()
        sender.borderStyle = UITextBorderStyle.None
        sender.resignFirstResponder()
    }
    // delegate
    
    // http://stackoverflow.com/questions/29621389/imagepickercontroller-broken-in-xcode-6-3
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedImage: UIImage = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        imageSpaceForMemePic.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
    }


}


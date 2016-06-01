//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Andrew Fruth on 10/26/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var savedMemeImageView: UIImageView!
    
    var savedMeme: Meme!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
        savedMemeImageView.image = savedMeme.memedImage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMemeSegue" {
            if let memeEditorVC = segue.destinationViewController as? MemeEditorViewController {
                memeEditorVC.savedMeme = savedMeme
            }
        }
    }
    
    @IBAction func editSavedMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editMemeSegue", sender: self)
    }
    
    
    
    
    
}

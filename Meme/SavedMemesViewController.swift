//
//  SavedMemesViewController.swift
//  Meme
//
//  Created by Andrew Fruth on 10/18/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

class SavedMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listOfMemes: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!

    
    let cellReuseIdentifier = "memeCell"
    var selectedIndex: Int?
    var memes: [Meme] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        if memes.count > 0 {
            listOfMemes.reloadData()
        }
    }
    
    @IBAction func backToSavedMemes(segue: UIStoryboardSegue) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        listOfMemes.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMemeSegue" {
            if let memeEditorVC = segue.destinationViewController as? MemeEditorViewController {
                if memeEditorVC.savedMeme != nil {
                    memeEditorVC.clearMeme()
                }
            }
        } else if segue.identifier == "showMemeDetail" {
            if let memeDetailVC = segue.destinationViewController as? MemeDetailViewController {
                if selectedIndex != nil {
                    let savedMeme = memes[selectedIndex!]
                    memeDetailVC.savedMeme = savedMeme
                }
            }
        }

    }
    
    
    
    // table data
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfMemes.delegate = self
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.imageView?.image = memes[indexPath.row].image
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("showMemeDetail", sender: self)
    }
}
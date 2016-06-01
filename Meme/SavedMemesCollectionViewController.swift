//
//  SavedMemesCollectionViewController.swift
//  Meme
//
//  Created by Andrew Fruth on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

class SavedMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionOfMemes: UICollectionView!
    let cellReuseIdentifier = "memeCollectionViewCell"
    var memes: [Meme] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionOfMemes.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCellModel
        cell.memeImageCell?.image = memes[indexPath.row].image
        cell.memeTopText?.text = findOnlyFirstXChar(memes[indexPath.row].topText, charactersToAllow: 10)
        cell.memeBottomText?.text = findOnlyFirstXChar(memes[indexPath.row].bottomText, charactersToAllow: 10)
         -1
        return cell
    }
    
    // https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language/26775912#26775912
    
    func findOnlyFirstXChar(phraseToSlice: String, charactersToAllow: Int) -> String {
        if charactersToAllow > phraseToSlice.characters.count - 1 {
            return phraseToSlice
        } else {
            let endIndex = phraseToSlice.startIndex.advancedBy(charactersToAllow)
            let slicedPhrase = phraseToSlice.substringWithRange(Range(start: phraseToSlice.startIndex, end: endIndex))
            return slicedPhrase
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Grab the DetailVC from Storyboard
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")
        let memeDetailVC = object as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        memeDetailVC.savedMeme = memes[indexPath.row]
        
        //Present the view controller using navigation
        navigationController!.pushViewController(memeDetailVC, animated: true)
    }
    
}
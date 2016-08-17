//
//  WholeChestsCollectionViewController.swift
//  CRHelper
//
//  Created by Fan Wu on 5/25/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class WholeChestsCollectionViewController: UICollectionViewController
{
    @IBOutlet var wholeChestsCollectionView: UICollectionView!
    private var chests = Chests()
    private var chestsCell = [(name: String, position: Int)]()
    
    private var storedChestPosition: Int
    {
        get { return NSUserDefaults.standardUserDefaults().objectForKey("chests.position") as? Int ?? 0}
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "chests.position") }
    }
    
    private struct Constants
    {
        static let borderColor = UIColor(red: 0.4235, green: 0.4235, blue: 0.4275, alpha: 0.8).CGColor
        static let borderWidth = CGFloat(2.5)
    }
    
    private func setCellBorder (cell: UICollectionViewCell?)
    {
        cell?.layer.borderWidth = Constants.borderWidth
        cell?.layer.borderColor = Constants.borderColor
    }
    
    // MARK: Whole Chests Collection View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for (index, value) in chests.chestsArray.enumerate()
        {
            chestsCell.append((value, index))
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        wholeChestsCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: storedChestPosition, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }
    
    // MARK: Whole Chests Collection View Datasource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return chestsCell.count
    }
    
    var trackReused = 0
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! WholeChestsCollectionViewCell
        
        if !chestsCell.isEmpty
        {
            cell.chest = chestsCell[indexPath.item]
        }
        
        if indexPath.item == storedChestPosition
        {
            setCellBorder(cell)
        }
        else
        {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    // MARK: Whole Chests Collection View Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //need to deselect the default chest first
        let selectedCell = wholeChestsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: storedChestPosition, inSection: 0))
        selectedCell?.layer.borderWidth = 0
        
        storedChestPosition = indexPath.item
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        setCellBorder(cell)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.layer.borderWidth = 0
    }
}

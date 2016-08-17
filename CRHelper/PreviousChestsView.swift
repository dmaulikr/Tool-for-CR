//
//  inputView.swift
//  CRHelper
//
//  Created by Fan Wu on 5/14/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class PreviousChestsView: UIView
{
    struct Constants
    {
        //set a maximum number when users enter previous chests
        static let numberOfPreviousChests = 10
        //set a number of chests per row showed in the screen
        static let chestsPerRow = 5
    }
    
    var chestsSize: CGSize
    {
        let size = UIScreen.mainScreen().bounds.size.width / CGFloat(Constants.chestsPerRow)
        return CGSize(width: size, height: size)
    }
    
    //use this property to caculate the number of previous chests users enter
    private var numberOfChests = 0
    
    //check the number of previous chests users enter whether is meet the maximum number or not
    private func chestsIsFull () -> Bool
    {
        if numberOfChests < Constants.numberOfPreviousChests
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    //add previous chests when users enter
    func addChests (name: String)
    {
        if !chestsIsFull()
        {
            var frame = CGRect(origin: CGPointZero, size: chestsSize)
            
            if numberOfChests < Constants.chestsPerRow
            {
                frame.origin.x = chestsSize.width * CGFloat(numberOfChests)
                let chestImageView = UIImageView(frame: frame)
                chestImageView.image = UIImage(named: name)
                self.addSubview(chestImageView)
                numberOfChests += 1
            }
            else
            {
                frame.origin.x = chestsSize.width * CGFloat(numberOfChests - Constants.chestsPerRow)
                frame.origin.y = chestsSize.height
                let chestImageView = UIImageView(frame: frame)
                chestImageView.image = UIImage(named: name)
                self.addSubview(chestImageView)
                numberOfChests += 1
            }
        }
    }
    
    //remove all the previous chests users enter
    func removeChests ()
    {
        numberOfChests = 0
        
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }
}

//
//  possibleChestsTableViewCell.swift
//  CRHelper
//
//  Created by Fan Wu on 5/19/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class PossibleChestsTableViewCell: UITableViewCell
{
    @IBOutlet weak var next1stPossibleChestPosition: UILabel!
    @IBOutlet weak var next2ndPossibleChestPosition: UILabel!
    @IBOutlet weak var next3rdPossibleChestPosition: UILabel!
    @IBOutlet weak var next4thPossibleChestPosition: UILabel!
    @IBOutlet weak var next5thPossibleChestPosition: UILabel!
    @IBOutlet weak var next1stPossibleChest: UIImageView!
    @IBOutlet weak var next2ndPossibleChest: UIImageView!
    @IBOutlet weak var next3rdPossibleChest: UIImageView!
    @IBOutlet weak var next4thPossibleChest: UIImageView!
    @IBOutlet weak var next5thPossibleChest: UIImageView!
    
    var nextPossibleChests = [(position: Int, chest: String)]()
    {
        didSet
        {
            updateCell()
        }
    }
    
    private func updateCell()
    {
        next1stPossibleChestPosition.text = String(nextPossibleChests[0].position)
        next2ndPossibleChestPosition.text = String(nextPossibleChests[1].position)
        next3rdPossibleChestPosition.text = String(nextPossibleChests[2].position)
        next4thPossibleChestPosition.text = String(nextPossibleChests[3].position)
        next5thPossibleChestPosition.text = String(nextPossibleChests[4].position)
        next1stPossibleChest.image = UIImage(named: nextPossibleChests[0].chest)
        next2ndPossibleChest.image = UIImage(named: nextPossibleChests[1].chest)
        next3rdPossibleChest.image = UIImage(named: nextPossibleChests[2].chest)
        next4thPossibleChest.image = UIImage(named: nextPossibleChests[3].chest)
        next5thPossibleChest.image = UIImage(named: nextPossibleChests[4].chest)
    }
}

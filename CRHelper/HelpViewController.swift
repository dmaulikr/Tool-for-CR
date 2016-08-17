//
//  HelpViewController.swift
//  CRHelper
//
//  Created by Fan Wu on 6/1/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController
{
    @IBOutlet weak var chestCycleText: UITextView!
    @IBOutlet weak var locateChestTest: UITextView!
    
    let chestCycleTestContent = NSLocalizedString("Besides Super Magical Chests, chests are not determined by chance, they are determined by a cycle.\n\nThe cycle does not advance if you have no empty chest slots. You must have a chest slot open to get the next chest and move forward in the cycle.\n\nThere are 180 Silver Chests, 52 Golden Chests, 4 Magical Chests and 4 Giant Chests in the 240 chests cycle.\n\nSuper Magical Chests are the only chests given by chance, which is 0.2%. And it will replace the one in the cycle.", comment: "chest cycle content")
    let locateChestTestContent = NSLocalizedString("You can enter up to 10 of your previous chests.\n\nMagical Chests and Giant Chests are called Rare Chests here.\n\nIn the Picker of “2 Previous Rare Chests”, right one is your previous Rare Chest, left one is the Rare Chests before your previous Rare Chest.\n\nBase on your input, if your input is valid, “Your Next Possible Coming 5 Chests” will show a result, and each row means one possibility.", comment: "locate chest content")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        chestCycleText.text = chestCycleTestContent
        locateChestTest.text = locateChestTestContent
    }

}

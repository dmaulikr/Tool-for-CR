//
//  wholeChestsCollectionViewCell.swift
//  CRHelper
//
//  Created by 吴凡 on 5/25/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class WholeChestsCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var chestImage: UIImageView!
    @IBOutlet weak var chestPosition: UILabel!
    
    var chest = (name: "", position: 0)
    {
        didSet
        {
            updateCell()
        }
    }
    
    private func updateCell()
    {
        chestImage.image = UIImage(named: chest.name)
        chestPosition.text = "\(chest.position)"
    }
}

//
//  LeaderCell.swift
//  WikiRandom
//
//  Created by Team Hurrange on 26/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

class LeaderCell: UITableViewCell
{
    @IBOutlet weak var trophyImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func configure(with item : User, index : PositionEnum)
    {
        switch index
        {
        
        case PositionEnum.FIRST :
            // Leader's nickname
            nicknameLabel.text = item.nickname
            // Leader's score
            scoreLabel.text = String(describing: item.score)
            trophyImageView.image = #imageLiteral(resourceName: "gold_medal")
        
        case PositionEnum.SECOND :
            // Leader's nickname
            nicknameLabel.text = item.nickname
            // Leader's score
            scoreLabel.text = String(describing: item.score)
            trophyImageView.image = #imageLiteral(resourceName: "silver_medal")
        
        case PositionEnum.THIRD :
            // Leader's nickname
            nicknameLabel.text = item.nickname
            // Leader's score
            scoreLabel.text = String(describing: item.score)
            trophyImageView.image = #imageLiteral(resourceName: "bronze_medal")
        
        default:
            // Leader's nickname
            nicknameLabel.text = item.nickname
            // Leader's score
            scoreLabel.text = String(describing: item.score)
        }
    }
}

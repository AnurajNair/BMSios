//
//  DashboardStatsCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 04/11/22.
//

import UIKit

class DashboardStatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var countNumber: UILabel!
    
    @IBOutlet weak var statName: UILabel!
    
    
    @IBOutlet weak var statsCard: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.statsCard.addConstraint(self.statsCard.widthAnchor.constraint(equalToConstant: UIScreen().bounds.fr))
//        self.statsCard.addConstraint(self.statsCard.heightAnchor.constraint(equalToConstant: 200))

        UIView.style([(view: self.statsCard, style:(backgroundColor:UIColor.BMS.dashboardCard, cornerRadius: 16, borderStyle: nil,shadowStyle : ShadowStyles.CardShadowStyle))])

        countNumber.textColor = UIColor.BMS.theme
        statName.textColor = UIColor.BMS.bmsLabelGrey

    }
    
    func configCell(count: Int, statName: String){
        self.countNumber.text = count.description
        self.statName.text = statName
        
    }
    
    

}



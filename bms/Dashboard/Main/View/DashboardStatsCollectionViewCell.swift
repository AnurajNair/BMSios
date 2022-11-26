//
//  DashboardStatsCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 04/11/22.
//

import UIKit

class DashboardStatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statsCard: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.statsCard.addConstraint(self.statsCard.widthAnchor.constraint(equalToConstant: UIScreen().bounds.fr))
//        self.statsCard.addConstraint(self.statsCard.heightAnchor.constraint(equalToConstant: 200))

        UIView.style([(view: self.statsCard, style:(backgroundColor:UIColor.SORT.fontGray, cornerRadius: 16, borderStyle: nil,shadowStyle : ShadowStyles.CardShadowStyle))])
        
    }

}

//
//  ReusableFooterLoadingView.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class ReusableFooterLoadingView: UIView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        activityIndicatorView.color = UIColor.SORT.gray
        self.backgroundColor = UIColor.SORT.clear
        activityIndicatorView.startAnimating()
    }

}

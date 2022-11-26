//
//  ReusableEmptyStateView.swift
//  bms
//
//  Created by Naveed on 16/10/22.
//

import UIKit

protocol ReusableEmptyStateViewDelegate: AnyObject {
    var emptyView: ReusableEmptyStateView { get set }
    
    func setupEmptyView(forScreenType screenType: NavigationRoute.ScreenType)
    func firstButtonTapped()
    
    /// - Note: Implement this function in your view controller to return backgroung image view height
    func getBackgroundImageViewHeight() -> CGFloat      /// Optional
    
    func getEmptyStateData(forScreenType screenType: NavigationRoute.ScreenType) -> EmptyStateViewStyler.EmptyViewData
}

extension ReusableEmptyStateViewDelegate where Self: UIViewController {
    
    
    func setupEmptyView(forScreenType screenType: NavigationRoute.ScreenType) {
        
        let data = getEmptyStateData(forScreenType: screenType)
        
        if emptyView.isDescendant(of: self.view) {
            emptyView.removeFromSuperview()
        }
        
        self.view.addSubview(emptyView)
        emptyView.layoutAllConstraints(parentView: self.view!)
    
        emptyView.isHidden = !data.shouldShowUpByDefault
        emptyView.delegate = self
        emptyView.updateData(data)
        view.sendSubviewToBack(emptyView)
    }
    
    func firstButtonTapped() { }
    
    func getBackgroundImageViewHeight() -> CGFloat {
        return self.view.frame.height
    }
    
    func getEmptyStateData(forScreenType screenType: NavigationRoute.ScreenType) -> EmptyStateViewStyler.EmptyViewData {
        return EmptyStateViewStyler.getEmptyViewData(forScreenType: screenType)
    }
}

extension ReusableEmptyStateViewDelegate where Self: UIView {
    func setupEmptyView(forScreenType screenType: NavigationRoute.ScreenType) {
        
        let data = getEmptyStateData(forScreenType: screenType)
        
        if emptyView.isDescendant(of: self) {
            emptyView.removeFromSuperview()
        }
        
        self.addSubview(emptyView)
        emptyView.layoutAllConstraints(parentView: self)
        
        emptyView.isHidden = !data.shouldShowUpByDefault
        emptyView.delegate = self
        emptyView.updateData(data)
        emptyView.backgroundColor = .clear
        bringSubviewToFront(emptyView)
    }
    
    func firstButtonTapped() { }
    
    func getBackgroundImageViewHeight() -> CGFloat {
        return self.frame.height
    }
    
    func getEmptyStateData(forScreenType screenType: NavigationRoute.ScreenType) -> EmptyStateViewStyler.EmptyViewData {
        return EmptyStateViewStyler.getEmptyViewData(forScreenType: screenType)
    }
}

class ReusableEmptyStateView: UIView {
    
    @IBOutlet weak var emptyViewVerticallyCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptyDescription: UILabel!
    @IBOutlet weak var emptyFirstButton: UIButton!
    @IBOutlet weak var emptyBackgroundImageView: UIImageView!
    @IBOutlet weak var emptyBackgroundImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    weak var delegate: ReusableEmptyStateViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        self.emptyTitle.font = EmptyStateViewStyler.emptyTitleFont
        self.emptyTitle.textColor = EmptyStateViewStyler.emptyTitleColor
        
        self.emptyDescription.font = EmptyStateViewStyler.emptyDescriptionFont
        self.emptyDescription.textColor = EmptyStateViewStyler.emptyDescriptionColor
        
        UIButton.style([(view: self.emptyFirstButton, title: "", style: EmptyStateViewStyler.emptyFirstButtonStyle)])
        
        self.emptyFirstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
    }
    
    func setupSmallView() {
        
        self.backgroundColor = .clear
        
        UILabel.style([(view: self.emptyTitle, style: TextStyles.PlaceDetailsRateLblStyle),(view: self.emptyDescription, style: TextStyles.ContactUsImageTitleStyle)])
    }
    
    //MARK:- Update Functions
    func updateData(_ data: EmptyStateViewStyler.EmptyViewData , ImageHeight : CGFloat = 100) {
        
        /// State Image, Background Image, Title and Message setup
        updateEmptyStateImage(data.image, imageContentMode: data.imageContentMode)
        updateBackgroundImage(data.backgroundImage, imageContentMode: data.backgroundImageContentMode, backgroundImageHeight: delegate?.getBackgroundImageViewHeight() ?? data.backgroundImageHeight)
        updateTitle(data.title, shouldShowTitle: data.shouldShowTitle)
        updateMessage(data.message)
        
        self.imageHeight.constant = ImageHeight
        
        /// Button Setup
        UIButton.style([(view: self.emptyFirstButton, title: data.buttonTitle, style: EmptyStateViewStyler.emptyFirstButtonStyle)])
        self.emptyFirstButton.isHidden = data.buttonTitle.isEmpty
        
        self.emptyViewVerticallyCenterConstraint.constant = data.emptyViewCenterConstraint
        
        self.layoutIfNeeded()
    }
    
    func updateEmptyStateImage(_ image: String, imageContentMode: UIView.ContentMode) {
        updateImage(image, imageContentMode: imageContentMode, forView: emptyImageView)
    }
    
    func updateBackgroundImage(_ image: String, imageContentMode: UIView.ContentMode, backgroundImageHeight: CGFloat) {
        updateImage(image, imageContentMode: imageContentMode, forView: emptyBackgroundImageView)
        self.emptyBackgroundImageViewHeightConstraint.constant = backgroundImageHeight
        self.layoutIfNeeded()
    }
    
    func updateImage(_ image: String, imageContentMode: UIView.ContentMode, forView imageView: UIImageView) {
        guard !image.isEmpty, let imageInstance = UIImage(named: image) else {
            imageView.isHidden = true
            return
        }
        
        imageView.image = imageInstance
        imageView.contentMode = imageContentMode
        imageView.isHidden = false
    }
    
    func updateTitle(_ title: String, shouldShowTitle: Bool = true) {
        self.emptyTitle.text = title
        self.emptyTitle.isHidden = !shouldShowTitle
    }
    
    func updateMessage(_ message: String) {
        self.emptyDescription.setText(to: message)
    }
    
    //MARK:- Action Functions
    @objc func firstButtonTapped() {
        self.delegate?.firstButtonTapped()
    }
}

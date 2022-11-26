//
//  ReusableFileCommonCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit
import WebKit

@objc protocol ReusableFileCommonCollectionViewCellDelegate:class {
    @objc optional func deleteButtonTapped(indexPath: IndexPath)
}

class ReusableFileCommonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addEditLabel: UILabel!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewRightConstraint: NSLayoutConstraint!
    
    var webView:WKWebView = WKWebView()
    
    weak var delegate:ReusableFileCommonCollectionViewCellDelegate?
    
    static let fileViewPadding:CGFloat = 12.0
    
    var id: IndexPath? = nil
    var file: Any? = nil
    var placeholderImage: String = ""
    
    var isRounded: Bool = false
    var canDelete: Bool = false
    var shouldShowDelete: Bool = false
    
    var shouldShowAddEditLabel: Bool = false
    
    var isWebView: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateCellPadding()
        self.updateFileViewRounding()
    }
    
    //MARK:- Setup Functions
    func setupView() {
        self.containerView.isUserInteractionEnabled = false
        self.mainImageView.isUserInteractionEnabled = false
        self.addEditLabel.isUserInteractionEnabled = false
        
        self.deleteButton.tintColor = FormElementStyler.File.fieldDeleteImageTintColor
        self.deleteButton.setImage(UIImage(named: FormElementStyler.File.fieldDeleteImageDefault)?.withRenderingMode(FormElementStyler.File.fieldDeleteImageRenderingMode), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        self.containerView.clipsToBounds = true
        self.addEditLabel.backgroundColor = FormElementStyler.File.fieldAddEditBackgroundColor
        self.addEditLabel.textColor = FormElementStyler.File.fieldAddEditTextColor
        self.addEditLabel.font = FormElementStyler.File.fieldAddEditFont
        self.addEditLabel.isHidden = true
        
        self.mainImageView.clipsToBounds = true
        
        let config = WKWebView.getWebViewConfig(scalePagesToFit: true)
        self.webView = WKWebView(frame: webViewContainer.frame, configuration: config)
        webViewContainer.addSubview(self.webView)
        webView.layoutAllConstraints(parentView: webViewContainer)
        self.webView.customizeWebView()
    
    }
    
    func setupView(_ file: Any? = nil,
                   isWebView: Bool = false,
                   placeholderImage: String = "",
                   id: IndexPath? = nil,
                   contentMode: UIView.ContentMode = .scaleAspectFit,
                   shouldShowAddEditLabel: Bool = false,
                   shouldShowDelete: Bool = false,
                   isRounded: Bool = false,
                   webViewScalesToFit: Bool = true) {
        
        self.file = file
        self.placeholderImage = placeholderImage
        self.id = id
        self.isWebView = isWebView
        
        self.mainImageView.contentMode = contentMode
        
        self.isRounded = isRounded
        self.shouldShowAddEditLabel = shouldShowAddEditLabel
        self.shouldShowDelete = shouldShowDelete
        self.canDelete = self.file != nil ? shouldShowDelete : false
        
        setupFile()
        handleAddEditText()
        handleEditingSetup()
        
    }
    
    func setupFile() {
        
        self.mainImageContainerView.isHidden = isWebView
        self.webViewContainer.isHidden = !isWebView
        
        if self.file != nil && !isWebView {
    
            if let value = file as? String {
                self.mainImageView.cacheImage(url: value, placeholderImage: self.placeholderImage)
            }
                
            else if let value = file as? URL {
                self.mainImageView.cacheImage(url: value.absoluteString, placeholderImage: self.placeholderImage)
            }
            
            else if let value = file as? UIImage {
                self.mainImageView.image = value
            }
        }
            
        else if self.file != nil && isWebView {
            
            var request: URL? = nil
            
            if let value = file as? URL {
                request = value
            }
                
            else if let value = file as? String {
                request =  URL(string: value)!
            }
            
            if let value = request {
                let mutableRequest = NSMutableURLRequest(url: value)
                webView.loadUrlRequest(mutableRequest)
            }
            
        }
            
        else {
            self.mainImageView.image = !self.placeholderImage.isEmpty ? UIImage(named: self.placeholderImage) : nil
        }
        
        setupFileViewStyling()
        
    }
    
    func setupFileViewStyling() {
        var fileStyle = FormElementStyler.File.fileViewStyle
        fileStyle.borderStyle = self.isRounded ? nil : fileStyle.borderStyle
        UIImageView.style([(view: mainImageView, style: fileStyle)])
        UIView.style([(view: webView, style: fileStyle)])
    }

    func handleEditingSetup() {
        
        self.deleteButton.isHidden = true
        
        if self.canDelete {
            self.deleteButton.isHidden = false
        }
        
    }
    
    func handleAddEditText() {
        
        self.addEditLabel.isHidden = true
        
        if self.shouldShowAddEditLabel {
            self.addEditLabel.isHidden = false
            
            self.addEditLabel.text = "Add".localized()
            
            if self.file != nil {
                if let value = file as? String, !value.isEmpty {
                    self.addEditLabel.text = "Edit".localized()
                } else if let _ = file as? UIImage {
                    self.addEditLabel.text = "Edit".localized()
                }
            }
            
        }
        
    }
    
    //MARK:- Action Functions
    @objc func deleteButtonTapped() {
        if self.id != nil {
            self.delegate?.deleteButtonTapped?(indexPath: self.id!)
        }
    }
    
    //MARK:- Helper Functions
    
    class func getFileViewPadding(shouldShowAddEditLabel: Bool = false, isDeletable: Bool = true, isRounded: Bool = false) -> CGFloat {
        
        if !shouldShowAddEditLabel && isDeletable && !isRounded {
            return ReusableFileCommonCollectionViewCell.fileViewPadding
        }
        
        return 0.0
    }
    
    func updateCellPadding() {
        let padding = ReusableFileCommonCollectionViewCell.getFileViewPadding(shouldShowAddEditLabel: self.shouldShowAddEditLabel, isDeletable: self.shouldShowDelete, isRounded: self.isRounded)
        self.containerViewTopConstraint.constant = padding
        self.containerViewRightConstraint.constant = padding
        self.layoutIfNeeded()
    }
    
    func updateFileViewRounding() {
        if self.isRounded {
            self.containerView.setRoundedView()
        } else {
            self.containerView.resetRoundedView()
        }
    }
}




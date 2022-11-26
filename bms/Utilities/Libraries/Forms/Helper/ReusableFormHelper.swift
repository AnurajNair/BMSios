//
//  ReusableFormHelper.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import SwiftValidator
//import DKImagePickerController

class ReusableFormHelper {
    
//    class func showMultiSelectImagePickerController(isSingleSelect: Bool, maxCount: Int, isCameraEnabled: Bool = true, completed: @escaping (_ data: [Any]) -> Void, cancelled: @escaping () -> Void) {
//
//        var data:[Any] = []
//
//        let pickerController = DKImagePickerController()
//        pickerController.singleSelect = isSingleSelect
//
//        if !isSingleSelect && maxCount > 0 {
//            pickerController.maxSelectableCount = maxCount
//        }
//
//        pickerController.navigationBar.barTintColor = FormElementStyler.FormHelper.imagePickerControllerBarTintColor
//        pickerController.navigationBar.tintColor = FormElementStyler.FormHelper.imagePickerControllerTintColor
//
//        pickerController.allowsLandscape = true
//        pickerController.sourceType = isCameraEnabled ? DKImagePickerControllerSourceType.both : DKImagePickerControllerSourceType.photo
//        pickerController.assetType = .allPhotos
//        pickerController.UIDelegate = CustomUIImagePickerDelegate()
//        pickerController.showsCancelButton = true
//        pickerController.showsEmptyAlbums = false
//
//        pickerController.didCancel = {() in
//            cancelled()
//        }
//
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            let downloadCount = assets.count
//            var currentCount = 0
//
//            if downloadCount == 0 {
//                completed(data)
//            }
//
//            Utils.showLoadingInRootView()
//
//            for asset in assets {
//
//                let _ = asset.fetchOriginalImage(options: nil, completeBlock: { (image, info) in
//
//                    if image != nil {
//
//                        if isSingleSelect {
//                            data = []
//                        }
//
//                        data.append(image!)
//                        currentCount += 1
//
//                        if currentCount == downloadCount{
//                            Utils.hideLoadingInRootView()
//                            completed(data)
//                        }
//
//                    }
//
//                })
//            }
//
//        }
//
//        Navigate.transitionToScreen(destinationViewController: pickerController, transitionType: .modal)
//
//    }
    
}

extension UIView {
    
    func setRoundedView() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.width/2
    }
    
    func resetRoundedView() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0.0
    }
    
    func setRoundedCorners(cornerRadius : CGFloat) {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layoutIfNeeded()
    }
    
}

extension UITextView: Validatable {
    
    public var validationText: String {
        return text ?? ""
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


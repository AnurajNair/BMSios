//
//  ImageUtils.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import SDWebImage
import IDMPhotoBrowser

class ImageUtils {
    
    //static let S3Bucket = Constants.s3Bucket
    
    //MARK:- Setup Functions
//    class func setupMediaStorageService() {
//        let accessKey = Constants.s3AccessKey
//        let secretKey = Constants.s3SecretKey
//
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
//        let configuration = AWSServiceConfiguration(region:AWSRegionType.APSouth1, credentialsProvider:credentialsProvider)
//
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
//    }
    
    //MARK:- Public Functions
    
//    class func uploadImages(_ localImages: [Any], bucket:String = S3Bucket, folderName:String = ImageUtils.generateFolderName(), filename:String, compression:CGFloat = 0.2, successCompletion: @escaping([String]) -> Void, errorCompletion: @escaping(String) -> Void) {
//
//        let total = localImages.count
//
//        if total == 0 {
//            successCompletion([])
//        }
//
//        var currentCount = 0
//        var imagesArray:[String] = []
//
//        for (index, image) in localImages.enumerated() {
//
//            if let uploadImage = image as? UIImage {
//
//                var file = filename
//
//                if localImages.count > 1 {
//                    file = filename + index.description
//                }
//
//                let path = folderName + randomizeFileName(file)
//
//                imagesArray.append(path)
//
//                let uploadRequest = getUploadRequest(uploadImage, bucket: bucket, folderName: folderName, filename: file, fullFilePath: path, compression: compression)
//
//                let transferManager = AWSS3TransferManager.default()
//                transferManager.upload(uploadRequest).continueOnSuccessWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
//
//                    if let error = task.error {
//                        errorCompletion(error.localizedDescription)
//                    }
//
//                    if task.result != nil {
//
//                        currentCount += 1
//
//                        if currentCount == total {
//                            successCompletion(imagesArray)
//                        }
//
//                    }
//
//                    return nil
//
//                })
//
//            }
//
//            else if let previousImage = image as? String {
//                imagesArray.append(previousImage)
//
//                currentCount += 1
//
//                if currentCount == total {
//                    successCompletion(imagesArray)
//                }
//
//            }
//
//        }
//
//    }
    
    class func clearImageCache(){
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    
    class func setupPhotoBrowser(_ urls: [Any] = [], selectedIndex: Int = 0, shouldTransition:Bool = true) -> IDMPhotoBrowser {
        
        var photoUrls:[NSURL] = []
        
        for url in urls {
            
            if let value = url as? NSURL {
                photoUrls.append(value)
            }
                
            else if let value = url as? String {
                photoUrls.append(NSURL(string: value)!)
            }
            
            else if let value = url as? UIImage, let localUrl = saveTemporaryImage(value, filename: "temp-photo-browser-\(Date().timeIntervalSince1970)") {
                let urlString = localUrl.absoluteString
                photoUrls.append(NSURL(string: urlString)!)
            }
            
        }
        
        if let photoBrowser = IDMPhotoBrowser(photoURLs: photoUrls) {
            photoBrowser.useWhiteBackgroundColor = true
            photoBrowser.displayActionButton = false
            photoBrowser.displayDoneButton = false
            photoBrowser.dismissOnTouch = true
            photoBrowser.setInitialPageIndex(UInt(selectedIndex))
            
            if shouldTransition {
                Navigate.transitionToScreen(destinationViewController: photoBrowser, transitionType: .modal, addNavigationController: false)
            }
            
            return photoBrowser
        }
        
        return IDMPhotoBrowser()
        
    }
    
    //MARK:- Helper Functions
    
//    private class func getUploadRequest(_ localImage: UIImage, bucket:String = S3Bucket, folderName:String = ImageUtils.generateFolderName(), filename:String, fullFilePath:String, compression:CGFloat = 0.5) -> AWSS3TransferManagerUploadRequest {
//
//        //Courtesy: https://github.com/maximbilan/Swift-Amazon-S3-Uploading-Tutorial
//
//        let S3BucketName = bucket
//
//        if let fileURL = saveTemporaryImage(localImage, filename: filename, compression: compression) {
//
//            let uploadRequest = AWSS3TransferManagerUploadRequest()!
//            uploadRequest.body = fileURL
//            uploadRequest.key = fullFilePath
//            uploadRequest.bucket = S3BucketName
//            uploadRequest.contentType = "image/jpeg"
//            uploadRequest.acl = .publicRead
//
//            return uploadRequest
//
//        }
//
//        return AWSS3TransferManagerUploadRequest()!
//
//    }
    
    private class func saveTemporaryImage(_ localImage: UIImage, filename: String, compression:CGFloat = 1.0) -> URL? {
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        let image = localImage
        let data = image.jpegData(compressionQuality: compression)
        do {
            try data?.write(to: fileURL)
            return fileURL
        }
        catch {
            return nil
        }
        
    }
    
//    class func setupImageSecurity() {
//
//        SDWebImageManager.shared().imageDownloader?.headersFilter = { url, headers in
//
//            let headerValues = Router.getAuthorizationHeaders()
//
//            let isSecure = url?.host == URL(string: Constants.apiBaseUrl)?.host
//
//            if isSecure {
//
//                var authHeaders = headers
//
//                for header in headerValues {
//                    let value = isSecure ? header.value : nil
//                    authHeaders?[header.HTTPHeaderField] = value
//                }
//
//                if let authHeadersCopy = authHeaders {
//                    return authHeadersCopy
//                }
//                return ["" : ""]
//
//            } else {
//
//                if let authHeaders = headers {
//                    return authHeaders
//                }
//                return  ["" : ""]
//
//            }
//        }
//
//    }
    
    class func generateFolderName() -> String {
        return Date().toString(format: "yyyy/MM/")
    }
    
    private class func randomizeFileName(_ filename: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(timestamp)" + filename + ".jpeg"
    }
    
    private class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    class func getImageUrl(_ endPoint : String) -> String{
        return "\(Constants.apiBaseUrl)\(endPoint)"
    }
    
    class func getMultipleUrl(_ imageDirectoryUrl : String , _ endPoint : String ) -> String{
        return "\(Constants.apiBaseUrl)\(imageDirectoryUrl)\(endPoint)"
    }
}

extension UIImageView {
    
    /**
     Loads image in image view.
     - parameter url: String representing image name or url.
     - parameter isRounded: Pass true if you want your image to be rounded.
     - parameter placeholderImage: placeholder image you want to display if image rendering fails.
     - parameter isRandomPlaceholder: Pass true if you want to display random color for placeholder.
     - parameter imageBackgroundColor:  Placeholder image background color which will be displayed when image rendering fails.
     - note: Pass 'isRandomPlaceholder' as 'false' if you are passing your custom imageBackgroundColor. And dont even pass placeHolderImage in this case.
     */
    func cacheImage(url: String, isRounded: Bool = false, placeholderImage: String = "", isRandomPlaceholder: Bool = false, imageBackgroundColor: UIColor = UIColor.SORT.imageBackgroundColor) {
        
        if isRounded {
            self.setRoundedImage()
        }
        
        if let image = UIImage(named: url) {
            self.image = image
        }
        
        else {
            
            var placeholder = UIImage()
            
            if !placeholderImage.isEmpty, let placeholderAsset = UIImage(named: placeholderImage) {
                placeholder = placeholderAsset
            }
                
            else {
                let color = isRandomPlaceholder ? getRandomColor() : imageBackgroundColor
                placeholder = UIImage().imageWithColor(color, width: self.frame.size.width, height: self.frame.size.height)
            }
            
            //ImageUtils.setupImageSecurity()
            
            self.sd_setImage(with: URL(string: url), placeholderImage: placeholder)
            
        }
        
    }
    
    func setRoundedImage() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.width/2
    }
    
    func resetRoundedImage() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0.0
    }
    
    func getRandomColor() -> UIColor {
        
        let colors = [UIColor.lightGray, UIColor.black, UIColor.blue, UIColor.green, UIColor.orange]
        
        let rand = arc4random_uniform(UInt32(colors.count))
        return colors[Int(rand)]
        
    }
    
}

extension UIImage {
    func convertToBase64String(compression: CGFloat = 1.0) -> String? {
        let imageData = self.jpegData(compressionQuality: compression)
        if let base64String = imageData?.base64EncodedString(options: .lineLength64Characters) {
            return "data:image/jpeg;base64,\(base64String)"
        }
        return nil
    }
    
    public var data: Data? {
        return self.jpegData(compressionQuality: 1)
    }
}

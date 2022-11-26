//
//  ReusableFormFileField.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit

@objc protocol ReusableFormFileFieldDelegate:class {
    @objc optional func fileViewDidChangeHeight(_ fileView: ReusableFormFileField, height: CGFloat)
    @objc optional func fileViewDidUpdateFiles(_ fileView: ReusableFormFileField, files: [[Any]])
    @objc optional func fileViewDidCancelAddingFiles(_ fileView: ReusableFormFileField, files: [Any])
    
    @objc optional func customFileSet(_ fileIndex : Int)
}

class ReusableFormFileField: UIView {
    
    @IBOutlet weak var containerStackView:UIStackView!
    @IBOutlet weak var uploadDocumentHolder:UIView!
    @IBOutlet weak var uploadDocumentStackView:UIStackView!
    @IBOutlet weak var addDocumentButton:UIButton!
    @IBOutlet weak var addImageButton:UIButton!
    @IBOutlet weak var editDocumentHolder:UIView!
    @IBOutlet weak var editDocumentButton:UIButton!
    @IBOutlet weak var editDocumentButtonTrailingConstraint:NSLayoutConstraint!
    @IBOutlet weak var collectionView:UICollectionView!
    
    weak var delegate: ReusableFormFileFieldDelegate?
    
    enum FileType {
        case webview
        case image
        case none
    }
    
    enum FieldSubtype {
        case images
        case documents
        case all
        case custom
    }
    
    enum PickerType{
        case imagePicker
        case popup
    }
    
    enum CellNames: String {
        case commonView = "ReusableFileCommonCollectionViewCell"
    }
    
    let cellIdentifiers:[String] = [CellNames.commonView.rawValue]
    
    var verticalSectionSpacing: CGFloat = 0.0
    var lineSpacing: CGFloat = 0.0
    var interItemSpacing: CGFloat = 0.0
    
    var id: Any = ""
    var data:[Any] = []
    var fileTypes:[FileType] = []
    var documentTypes:[String] = []
    var fieldSubtype:FieldSubtype = .all
    var maxHeight: CGFloat = 0.0
    var maxCount: Int = 0
    var numberOfItemsPerRow: CGFloat = 0.0
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var previewAspectRatio: CGFloat = 1.0
    var previewImageContentMode: UIView.ContentMode = .scaleAspectFit
    var previewWebScaleToFit: Bool = true
    var isAddPositionFirst: Bool = true
    var isRoundedPreview: Bool = false
    var isViewCentered: Bool = true
    var addPreviewImagePlaceholder: String = ""
    var displayPreviewImagePlaceholder: String = ""
    var editingEnabled: Bool = true
    var indexForAdd: Int = 0
    var isSingleSelect: Bool = false
    var canDelete: Bool = true
    var isPreviewEnabled: Bool = true
    var isCameraEnabled: Bool = true
    
    var frameWidth: CGFloat = 0.0
    var cellHeight: CGFloat = 0.0
    var cellWidth: CGFloat = 0.0
    
    var imagePadding: CGFloat = 0.0
    
    var maxFileSizeAllowedInMB: Double = 0
    var fileSizeErrorMessage: String = FormElementStyler.File.fileSizeErrorMessage
    
    var selectedIndexPath : IndexPath?
    
    var customPickerStyle : (title : String,sourceFiles:[Any],fileTypes: [FileType],fieldSubtype: FieldSubtype,fieldPickerType: PickerType,documentTypes: [String],addPreviewImagePlaceholder: String,displayPreviewImagePlaceholder: String,isRoundedPreview: Bool,previewAspectRatio: CGFloat,previewImageContentMode: UIView.ContentMode ,previewWebScaleToFit: Bool,numberOfItemsInRow : Int ,minimumItemSpacing : Int)?
    
    //Imports - URLs, UIImages, Strings PDF, Strings Image
    //Exports - URLs, UIImages, Strings
    
    override init (frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fromNib()
        initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frameWidth != self.frame.size.width {
            self.frameWidth = self.frame.size.width
            self.updateHeight(true)
        }
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        
        self.frameWidth = self.frame.size.width
        setupCollectionView()
        
        UIButton.style([(view: addDocumentButton, title: "Add File", style: FormElementStyler.File.addDocumentButtonStyle),
                        (view: addImageButton, title: "Add Image", style: FormElementStyler.File.addImageButtonStyle),
                        (view: editDocumentButton, title: "Edit File", style: FormElementStyler.File.editDocumentButtonStyle)])
        
        self.addDocumentButton.addTarget(self, action: #selector(addDocument), for: .touchUpInside)
       // self.addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.editDocumentButton.addTarget(self, action: #selector(editFile), for: .touchUpInside)
        
        self.uploadDocumentStackView.spacing = FormElementStyler.File.uploadDocumentHolderSpacing
        
    }
    
    func setupCollectionView() {
        self.collectionView.backgroundColor = FormElementStyler.File.galleryBackgroundColor
        self.collectionView.bounces = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerNibs(cellIdentifiers)
    }
    
    //MARK:- Update Functions
    
    func setupFileField(id:Any = "",
                        files: [Any] = [],
                        fileTypes: [FileType] = [],
                        fieldSubtype: FieldSubtype = .all,
                        documentTypes: [String] = ["public.png", "public.jpeg", "com.adobe.pdf"],
                        isEditable: Bool = true,
                        canDelete: Bool = true,
                        isAddPositionFirst: Bool = true,
                        addPreviewImagePlaceholder: String = "",
                        displayPreviewImagePlaceholder: String = "",
                        isRoundedPreview: Bool = false,
                        isViewCentered: Bool = true,
                        previewAspectRatio: CGFloat = 1.0,
                        previewImageContentMode: UIView.ContentMode = .scaleAspectFit,
                        previewWebScaleToFit: Bool = true,
                        maxHeight: CGFloat = 0.0,
                        maxCount: Int = 0,
                        scrollDirection: UICollectionView.ScrollDirection = .vertical,
                        numberOfItemsPerRow: CGFloat = 1.0,
                        isPreviewEnabled: Bool = true,
                        isCameraEnabled: Bool = true,
                        maxFileSizeAllowedInMB: Double = 0,
                        fileSizeErrorMessage: String = FormElementStyler.File.fileSizeErrorMessage) {
        
        self.id = id
        self.data = files
        self.fileTypes = fileTypes
        self.fieldSubtype = fieldSubtype
        self.documentTypes = documentTypes
        
        self.maxFileSizeAllowedInMB = maxFileSizeAllowedInMB
        self.fileSizeErrorMessage = fileSizeErrorMessage
        
        self.scrollDirection = scrollDirection
        self.numberOfItemsPerRow = numberOfItemsPerRow
        
        if self.scrollDirection == .vertical {
            self.numberOfItemsPerRow = ceil(numberOfItemsPerRow)
        }
        
        self.previewAspectRatio = previewAspectRatio
        self.previewImageContentMode = previewImageContentMode
        
        self.maxHeight = maxHeight
        self.maxCount = maxCount
        
        self.editingEnabled = isEditable
        self.canDelete = canDelete
        self.isAddPositionFirst = isAddPositionFirst
        self.addPreviewImagePlaceholder = addPreviewImagePlaceholder
        self.displayPreviewImagePlaceholder = displayPreviewImagePlaceholder
        self.isRoundedPreview = isRoundedPreview
        self.isViewCentered = isViewCentered
        self.isPreviewEnabled = isPreviewEnabled
        self.isCameraEnabled = isCameraEnabled
        
        self.isSingleSelect = self.maxCount == 1
        
        self.addDocumentButton.isEnabled = self.editingEnabled
        self.addImageButton.isEnabled = self.editingEnabled
        
        toggleViews()
        layoutCollectionView()
        updateHeight()
        
    }
    
    
    
    func setupCustomPicker(title : String = "",
                           sourceFiles:[Any] = [],
                           fileTypes: [FileType] = [],
                           fieldSubtype: FieldSubtype = .all,
                           fieldPickerType: PickerType = .imagePicker,
                           documentTypes: [String] = ["public.png", "public.jpeg", "com.adobe.pdf"],
                           addPreviewImagePlaceholder: String = "",
                           displayPreviewImagePlaceholder: String = "",
                           isRoundedPreview: Bool = false,
                           previewAspectRatio: CGFloat = 1.0,
                           previewImageContentMode: UIView.ContentMode = .scaleAspectFit,
                           previewWebScaleToFit: Bool = true,
                           numberOfItemsInRow : Int = 4,
                           minimumItemSpacing : Int = 2){
        
        customPickerStyle = (title : title,sourceFiles:sourceFiles,fileTypes: fileTypes,fieldSubtype: fieldSubtype,fieldPickerType: fieldPickerType,documentTypes: documentTypes,addPreviewImagePlaceholder: addPreviewImagePlaceholder,displayPreviewImagePlaceholder: displayPreviewImagePlaceholder,isRoundedPreview: isRoundedPreview,previewAspectRatio: previewAspectRatio,previewImageContentMode: previewImageContentMode ,previewWebScaleToFit: previewWebScaleToFit,numberOfItemsInRow : numberOfItemsInRow ,minimumItemSpacing : minimumItemSpacing)
        
    }
    
    //MARK:- Helper Functions
    
    func refreshCollectionView() {
        setIndexForAddingFiles()
        self.collectionView.reloadData()
    }
    
    func toggleViews() {
        
        switch fieldSubtype {
            
        case .images , .custom:
            
            self.editDocumentHolder.isHidden = true
            self.editDocumentButton.isHidden = true
            self.uploadDocumentHolder.isHidden = true
            self.collectionView.isHidden = false
            
        default:
            
            self.collectionView.isHidden = self.data.count == 0
            
            let showEditButton = self.data.count != 1 || !isSingleSelect || !self.editingEnabled
            self.editDocumentHolder.isHidden = showEditButton
            self.editDocumentButton.isHidden = showEditButton
            
            self.uploadDocumentHolder.isHidden = self.data.count != 0
            self.addImageButton.isHidden = fieldSubtype == .documents
            
        }
        
    }
    
    func setupButtonsStyling() {
        
        self.uploadDocumentHolder.layoutIfNeeded()
        
        if let value = FormElementStyler.File.addDocumentButtonStyle.buttonImage, !value.isEmpty {
            
            if fieldSubtype != .documents {
                self.addDocumentButton.setButtonImageFromRightWithPadding(FormElementStyler.File.buttonImagePadding, titleLeftPadding: FormElementStyler.File.buttonImagePadding, isTitleCentered: false)
            }
            
            else {
                self.addDocumentButton.inverseButtonImageWithPadding()
            }
            
        }
        
        if let value = FormElementStyler.File.addImageButtonStyle.buttonImage, !value.isEmpty {
            self.addImageButton.setButtonImageFromRightWithPadding(FormElementStyler.File.buttonImagePadding, titleLeftPadding: FormElementStyler.File.buttonImagePadding, isTitleCentered: false)
        }
        
        if let value = FormElementStyler.File.editDocumentButtonStyle.buttonImage, !value.isEmpty {
            self.editDocumentButton.contentHorizontalAlignment = .right
            self.editDocumentButton.inverseButtonImageWithPadding(inBetweenPadding: FormElementStyler.File.buttonImagePadding)
            self.editDocumentButtonTrailingConstraint.constant = imagePadding
            self.editDocumentHolder.layoutIfNeeded()
        }
        
    }
    
    func setIndexForAddingFiles() {
        if self.isAddPositionFirst || self.isSingleSelect || self.data.count == 0 {
            self.indexForAdd = 0
        } else {
            self.indexForAdd = self.data.count
        }
    }
    
    func getFileIndex(_ indexPath: IndexPath) -> IndexPath {
        if self.indexForAdd == 0 && shouldShowAddInMultiSelect() {
            return IndexPath(row: indexPath.row - 1, section: indexPath.section)
        }
        
        return indexPath
    }
    
    func layoutCollectionView() {
        
        let layout: UICollectionViewFlowLayout = ReusableFormCollectionViewFlowLayout()
        
        if self.scrollDirection == .vertical {
            lineSpacing = getInterItemSpacing(5)
            interItemSpacing = getInterItemSpacing(5)
        }
            
        else if self.scrollDirection == .horizontal {
            interItemSpacing = getInterItemSpacing(5)
            lineSpacing = getInterItemSpacing(5)
            
        }
        
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = self.scrollDirection
        
        verticalSectionSpacing = 0
        
        if self.isSingleSelect {
            verticalSectionSpacing = 5
        }
        
        layout.sectionInset = UIEdgeInsets.init(top: verticalSectionSpacing, left: 0, bottom: verticalSectionSpacing, right: 0)
        
        self.collectionView.collectionViewLayout = layout
    }
    
    func getInterItemSpacing(_ currentSpacing: CGFloat) -> CGFloat {
        return (self.isRoundedPreview || !self.editingEnabled) ? currentSpacing * 2 : currentSpacing
    }
    
    func centerView() {
        
        if self.isViewCentered && self.isSingleSelect {
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let inset = (self.frame.size.width - self.cellWidth)/2
                layout.sectionInset.left = inset
                layout.sectionInset.right = inset
            }
        }
    }
    
    func updateHeight(_ shouldDelegate: Bool = false) {
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        updateCellItemSize()
        
        if shouldDelegate {
            self.layoutIfNeeded()
        }
        
        let frameHeight = getViewHeight()
        self.frame.size.height = frameHeight
        
        centerView()
        
        if self.maxHeight == 0.0 && shouldDelegate {
            self.delegate?.fileViewDidChangeHeight?(self, height: frameHeight)
        }
        
        refreshCollectionView()
        setupButtonsStyling()
        
    }
    
    func getViewHeight() -> CGFloat {
        
        var frameHeight:CGFloat = 0.0
        
        if !self.collectionView.isHidden {
            frameHeight += self.maxHeight > 0.0 ? self.maxHeight: getCollectionViewHeight()
        }
        
        if !self.uploadDocumentHolder.isHidden {
            frameHeight += 38.0
//            frameHeight += self.uploadDocumentHolder.frame.size.height
        }
        
        if !self.editDocumentHolder.isHidden {
            frameHeight += 38.0
//            frameHeight += self.editDocumentHolder.frame.size.height
        }
        
        return frameHeight
        
    }
    
    func getInterItemSpacing() -> CGFloat {
        
        var spacing =  interItemSpacing
        if self.scrollDirection == .horizontal {
            spacing = lineSpacing
        }
        
        return spacing
    }
    
    func updateCellItemSize() {
        
        let spacing =  getInterItemSpacing()
        
        let totalInterItemSpacing = (spacing * (numberOfItemsPerRow - 1))
        self.cellWidth = (self.frame.size.width - totalInterItemSpacing) / self.numberOfItemsPerRow
        
        imagePadding = ReusableFileCommonCollectionViewCell.getFileViewPadding(shouldShowAddEditLabel: shouldShowAddEditLabel(), isDeletable: isDeletable(), isRounded: self.isRoundedPreview)
        
        let imageWidth = self.cellWidth - imagePadding //Preview View Padding - Left & Right
        self.cellHeight = (imageWidth * self.previewAspectRatio) + imagePadding //padding for the top and bottom padding
    }
    
    func getCollectionViewHeight() -> CGFloat {
        
        if self.scrollDirection == .vertical {
            
            let numberRows = ceil(CGFloat(self.numberOfItemsInView()) / self.numberOfItemsPerRow)
            var totalHeight = numberRows * cellHeight
            totalHeight += ((numberRows - 1) * lineSpacing) + (2 * verticalSectionSpacing)
            return ceil(totalHeight)
            
        }
        
        return ceil((2 * verticalSectionSpacing) + cellHeight)
        
    }
    
    func numberOfItemsInView() -> Int {
        
        if shouldShowAddInMultiSelect() {
            return self.data.count + 1
        }
        
        else if !self.isSingleSelect {
            return self.data.count
        }
        
        return 1
        
    }
    
    func shouldUpdateSavedImages() {
        
        let collectionViewHiddenState = self.collectionView.isHidden
        
        toggleViews()
        
        //Need to update the height only when it's vertical or as and when the collection view hidden state changes
        let shouldUpdateHeight = self.scrollDirection == .vertical || self.collectionView.isHidden != collectionViewHiddenState
        
        self.delegate?.fileViewDidUpdateFiles?(self, files: [self.data, self.fileTypes])
        
        if shouldUpdateHeight  {
            self.updateHeight(true)
        }
        
        refreshCollectionView()
        
    }
    
    func cancelledPickerView() {
        self.delegate?.fileViewDidCancelAddingFiles?(self, files: self.data)
    }
    
    func isDeletable() -> Bool {
        return self.canDelete && self.editingEnabled
    }
    
    func shouldShowAddEditLabel() -> Bool {
        return self.isSingleSelect && (self.fieldSubtype == .images || self.fieldSubtype == .custom)  && self.editingEnabled
    }
    
    func shouldShowAddInMultiSelect() -> Bool {
        return !self.isSingleSelect && ((self.data.count > 0 && self.editingEnabled) || (self.data.count == 0))
    }
    
    func isImageExtension(_ url: URL) -> Bool {
        
        let imageExtensions = ["png", "jpg", "jpeg"]
        
        if imageExtensions.contains(url.pathExtension) {
            return true
        }
        
        return false
    }
    
    class func isLocalDocument(_ fileData: Any? = nil) -> Bool {
        
        if let value = fileData as? String, ReusableFormFileField.isLocalFile(value) {
            return true
        }
            
        else if let value = fileData as? URL, ReusableFormFileField.isLocalFile(value.absoluteString) {
            return true
        }
            
        else if fileData is UIImage {
            return true
        }
        
        return false
    }
    
    private class func isLocalFile(_ url: String) -> Bool {
        if let value = URL(string: url) {
            return value.isFileURL
        }
        return false
    }
    
    /**
     Validates file size and displays alert if validation fails
     - parameters: data(Data): accepts 'Data' object for which file size needs to be validated.
     - returns: Bool value specifying given data is under maximum file size or not. If below allowed file size then returns 'true' else returns 'false'
     */
    func hasValidFileSize(_ data: Data) -> Bool {
        if maxFileSizeAllowedInMB > 0, data.sizeInMB > maxFileSizeAllowedInMB {
            // File size is greater than allowed file size
            Utils.displayAlert(title: "Error", message: String(format: fileSizeErrorMessage, maxFileSizeAllowedInMB))
            return false
        }
        return true
    }
    
    func setDataForNewObjects(_ objects: [Any]) {
        
        var newFileTypes:[FileType] = []
        var validFileSize = false
        
        for object in objects {
            
            if let image = object as? UIImage {
                
                /// Convert to Data and validate file size
                if let data = image.data {
                    validFileSize = hasValidFileSize(data)
                }
                
                /// Append only if file size validation is passed
                if validFileSize {
                    newFileTypes.append(.image)
                } else {
                    break
                }
            }
            
            else if let value = object as? URL {
                
                do {
                    /// Convert to Data and validate file size
                    let data = try Data(contentsOf: value)
                    validFileSize = hasValidFileSize(data)
                    
                    /// Append only if file size validation is passed
                    if validFileSize {
                        
                        if isImageExtension(value) {
                            newFileTypes.append(.image)
                        }else {
                            newFileTypes.append(.webview)
                        }
                        
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            
            else {
                newFileTypes.append(.none)
            }
            
        }
        
        guard validFileSize else {return}
        
        if isSingleSelect {
            self.data = objects
            self.fileTypes = newFileTypes
        } else {
            self.data += objects
            self.fileTypes += newFileTypes
        }
        
    }
    
    //MARK:- Action Functions
    @objc func addDocument() {
        
        let fileManager = FileManager.default
        
        if let _ = fileManager.url(forUbiquityContainerIdentifier: nil) {
        
            let documentPicker = UIDocumentPickerViewController(documentTypes: self.documentTypes, in: .import)
            documentPicker.delegate = self
            
            if #available(iOS 11.0, *) {
                documentPicker.allowsMultipleSelection = !self.isSingleSelect
            } else {
                // Fallback on earlier versions
            }
            
            Navigate.transitionToScreen(destinationViewController: documentPicker, transitionType: .modal, addNavigationController: false)
        
        }
        
        else {
            
            debugPrint("ERROR FOR DEV Please enable the iCloud Entitlements for the document picker to work")
            
            if #available(iOS 11.0, *) {
                Utils.displayAlert(title: "Error", message: "Please install the iOS Files App from the App Store in order to upload a document")
            }
                
            else {
                Utils.displayAlert(title: "Error", message: "Please enable iCloud Drive from the Settings App in order to upload a document")
            }
            
        }
        
    }
    
//    @objc func addImage() {
//
//        ReusableFormHelper.showMultiSelectImagePickerController(isSingleSelect: self.isSingleSelect, maxCount: self.maxCount - self.data.count, isCameraEnabled: isCameraEnabled, completed: { (response) in
//
//            self.setDataForNewObjects(response)
//            self.shouldUpdateSavedImages()
//
//        }, cancelled: {
//            self.cancelledPickerView()
//        })
//
//    }
    
//    func editSingleImage(_ indexPath: IndexPath) {
//
//        if self.isPreviewEnabled && self.data.count > 0 {
//
//            var actions: [(String, String , UIAlertAction.Style, (() -> Void))] = []
//
//            let primaryAction: (String,String, UIAlertAction.Style, (() -> Void)) = ("Edit Image", "" ,
//                                                                             .default,
//                                                                             { self.addImage() })
//
//            actions.append(primaryAction)
//
//            let secondaryAction: (String,String, UIAlertAction.Style, (() -> Void)) = ("Preview Image", "",
//                                                                               .default,
//                                                                               { self.previewFile(indexPath) })
//
//            actions.append(secondaryAction)
//
//            let cancelAction: (String,String , UIAlertAction.Style, (() -> Void)) = ("Cancel", "" ,
//                                                                            .default,
//                                                                            {})
//            actions.append(cancelAction)
//
//            let _ = Utils.displayActionSheet(title: "Choose from the options below", message: nil, viewTintColor: FormElementStyler.File.fileActionSheetTextColor, actions: actions)
//
//        }
//
//        else {
//            self.addImage()
//        }
//
//    }
    
    @objc func editFile() {
        uploadMoreFiles(true)
    }
    
    func uploadMoreFiles(_ isEditing: Bool = false) {
        var actions: [(String, String ,UIAlertAction.Style, (() -> Void))] = []
        
        let imageString = isEditing ? "Edit Image" : "Upload Image"
        let documentString = isEditing ? "Edit File" : "Upload File"
        
//        if fieldSubtype != .documents {
//            let primaryAction: (String,String, UIAlertAction.Style, (() -> Void)) = (imageString, "",
//                                                                             .default,
//                                                                             { self.addImage() })
//            
//            actions.append(primaryAction)
//        }
        
        let secondaryAction: (String,String, UIAlertAction.Style, (() -> Void)) = (documentString, "",
                                                                           .default,
                                                                           { self.addDocument() })
        
        actions.append(secondaryAction)
        
        let cancelAction: (String, String ,UIAlertAction.Style, (() -> Void)) = ("Cancel", "",
                                                                        .default,
                                                                        {})
        actions.append(cancelAction)
        
        let _ = Utils.displayActionSheet(title: "Choose from the options below", message: nil, viewTintColor: FormElementStyler.File.fileActionSheetTextColor, actions: actions)
    }
    
    @objc func removeFile(_ indexPath: IndexPath) {
        
        let deleteIndex = getFileIndex(indexPath).row
        self.data.remove(at: deleteIndex)
        self.shouldUpdateSavedImages()
        
    }
    
    @objc func previewFile(_ indexPath: IndexPath) {
        
        let index = getFileIndex(indexPath).row
        let fileUrl = self.data[index]
        let type:FileType = self.fileTypes.count > index ? self.fileTypes[index] : .none
        
        if type == .webview {
            
            var urlString:String = ""
            
            if let value = fileUrl as? URL {
                urlString = value.absoluteString
            }
                
            else if let value = fileUrl as? String {
                urlString = value
            }
            
            Navigate.routeUserToScreen(screenType: .webView, transitionType: .modal, data: ["url": urlString, "scalePagesToFit": true, "allowBackForward": false], screenTitle: "Preview")
            
        }
        
        else if (fieldSubtype == .images || fieldSubtype == .custom) {
            let _ = ImageUtils.setupPhotoBrowser(self.data, selectedIndex: index)
        }
        
        else {
            let _ = ImageUtils.setupPhotoBrowser([fileUrl])
        }
        
    }
    
}

extension ReusableFormFileField: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let urlArray:[Any] = urls
        
       if self.maxCount > 0 && (urlArray.count > self.maxCount - self.data.count) && !self.isSingleSelect {
            Utils.displayAlert(title: "Error", message: "You can add only \(self.maxCount - self.data.count) files more")
        }
        
       else {
            
            self.setDataForNewObjects(urlArray)
            shouldUpdateSavedImages()
            
        }
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        cancelledPickerView()
    }
    
}

extension ReusableFormFileField: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.commonView.rawValue, for: indexPath) as? ReusableFileCommonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        var fileUrl: Any? = nil
        var contentMode = self.previewImageContentMode
        var placeHolderImage = self.displayPreviewImagePlaceholder
        var isWebView: Bool = false
       
        if (self.isSingleSelect && self.data.count == 0) || (shouldShowAddInMultiSelect() && indexPath.row == self.indexForAdd) {
            
            //This means it's there's no image or the box to add a file in multi-select as long as editing is enabled
            
            contentMode = .scaleToFill
            placeHolderImage = self.addPreviewImagePlaceholder
            
        }
        
        else {
            fileUrl = self.data[getFileIndex(indexPath).row]
            let type:FileType = self.fileTypes.count > getFileIndex(indexPath).row ? self.fileTypes[getFileIndex(indexPath).row] : .none
            isWebView = type == .webview
        }
        
        cell.setupView(fileUrl,
                       isWebView: isWebView,
                       placeholderImage: placeHolderImage,
                       id: indexPath,
                       contentMode: contentMode,
                       shouldShowAddEditLabel: shouldShowAddEditLabel(),
                       shouldShowDelete: isDeletable(),
                       isRounded: self.isRoundedPreview,
                       webViewScalesToFit: previewWebScaleToFit)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView.contentOffset
    }
    
}

extension ReusableFormFileField: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
}

extension ReusableFormFileField: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.editingEnabled && indexPath.row == self.indexForAdd && self.editDocumentHolder.isHidden {
            
            if !self.isSingleSelect && self.maxCount > 0 && self.data.count >= self.maxCount {
                let stringValue = "\(maxCount) file".pluralizeForInt(self.maxCount)
                Utils.displayAlert(title: "Maximum Limit Reached", message: "You can select a maximum of \(stringValue)")
            }
                
            else {
                
                switch self.fieldSubtype {
                case .images:
                    
                    if isSingleSelect {
                        //self.editSingleImage(indexPath)
                    }
                    
                    else {
//                        self.addImage()
                    }
                case .custom:
                    selectedIndexPath = indexPath
                    let customStylePicker = (title : customPickerStyle?.title ?? "",sourceFiles:customPickerStyle?.sourceFiles ?? [],documentTypes: customPickerStyle?.documentTypes ?? [],addPreviewImagePlaceholder: customPickerStyle?.addPreviewImagePlaceholder ?? "",displayPreviewImagePlaceholder: customPickerStyle?.displayPreviewImagePlaceholder ?? "",isRoundedPreview: customPickerStyle?.isRoundedPreview ?? false,previewAspectRatio: customPickerStyle?.previewAspectRatio ?? 0,previewImageContentMode: customPickerStyle?.previewImageContentMode ?? .scaleAspectFit ,previewWebScaleToFit: customPickerStyle?.previewWebScaleToFit,numberOfItemsInRow : customPickerStyle?.numberOfItemsInRow ,minimumItemSpacing : customPickerStyle?.minimumItemSpacing)
                    
                    let isPopup = customPickerStyle?.fieldPickerType == .popup
                    let transitionType : Navigate.TransitionType = isPopup ? .popup : .modal
                    
                    NavigationRoute.routeUserToScreen(screenType: .imagePicker, transitionType: transitionType, data: ["customStyle" : customStylePicker , "isPopup" : isPopup , "delegate" : self], screenTitle: "", contentSize: CGSize(width: Constants.screenBounds.width - 32, height: Constants.screenBounds.width - 32))
                    
                default:
                    self.uploadMoreFiles()
                }
                
            }
            
        }
        
        else if self.isPreviewEnabled && self.data.count > 0 {
            previewFile(indexPath)
        }
        
    }
    
}

extension ReusableFormFileField: ReusableFileCommonCollectionViewCellDelegate {
    
    func deleteButtonTapped(indexPath: IndexPath) {
        removeFile(indexPath)
    }
    
}

extension ReusableFormFileField : ReusableFormFileFieldDelegate{
    func customFileSet(_ fileIndex: Int) {
        guard let cellItem =  collectionView.cellForItem(at: selectedIndexPath!) as? ReusableFileCommonCollectionViewCell else{
            return
        }
        
        cellItem.file = customPickerStyle?.sourceFiles[fileIndex]
        cellItem.setupFile()
        
        self.delegate?.fileViewDidUpdateFiles?(self, files: [[fileIndex]])
    
    }
}


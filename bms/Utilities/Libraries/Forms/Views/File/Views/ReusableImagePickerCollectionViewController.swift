//
//  ReusableImagePickerCollectionViewController.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit
import RealmSwift

class ReusableImagePickerCollectionViewController: UICollectionViewController {
    
    enum CellNames: String {
        case commonView = "ReusableFileCommonCollectionViewCell"
    }
    let cellIdentifiers:[String] = [CellNames.commonView.rawValue]
    
    var data : [String] = []
    
    typealias CustumPickerDataType = (title : String,sourceFiles:[Any],documentTypes: [String],addPreviewImagePlaceholder: String,displayPreviewImagePlaceholder: String,isRoundedPreview: Bool,previewAspectRatio: CGFloat,previewImageContentMode: UIView.ContentMode ,previewWebScaleToFit: Bool,numberOfItemsInRow : Int ,minimumItemSpacing : Int)
    
    var customPickerStyle : CustumPickerDataType?
    
    var isPopup : Bool = false
    
    var delegate : ReusableFormFileFieldDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        setupViews()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Setup Views
    
    func setupViews(){
        setupCollectionView()
        setupData()
        self.collectionView.reloadData()
    }
    
    func setupData(){
        if let themes = customPickerStyle?.sourceFiles as? [String] {
            self.data = themes
        }
        
        self.title = customPickerStyle?.title ?? ""
    }
    
    func setupCollectionView(){
        let minimuItemSpacing = CGFloat(customPickerStyle?.minimumItemSpacing ?? 0)
        let itemsInRow = customPickerStyle?.numberOfItemsInRow ?? 0
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: minimuItemSpacing, left: minimuItemSpacing, bottom: minimuItemSpacing, right: minimuItemSpacing)
        let viewWidth = isPopup ? view.bounds.size.width - 32 : view.bounds.size.width
        let itemWidth = ((viewWidth - (CGFloat(itemsInRow + 1) * minimuItemSpacing)) / 4)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = minimuItemSpacing
        layout.minimumLineSpacing = minimuItemSpacing
        collectionView.collectionViewLayout = layout
        self.collectionView.registerNibs(cellIdentifiers)
        collectionView.backgroundColor = UIColor.white
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.commonView.rawValue, for: indexPath) as? ReusableFileCommonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        var fileUrl : String = ""
        
        fileUrl = self.data[indexPath.item]
        
        cell.setupView(fileUrl,
                       id: indexPath)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.customFileSet?(indexPath.item)
        }
    }
}

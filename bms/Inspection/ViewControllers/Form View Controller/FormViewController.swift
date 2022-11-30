//
//  BridgeDetailFormViewController.swift
//  bms
//
//  Created by Naveed on 27/10/22.
//

import UIKit

class FormViewController: UIViewController, UICollectionViewDataSource {
  
    
    
    
    
    let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    let arr = [1,2,3]
    
   
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var formTitleLbl: UILabel!
    var formDetails: sections?  = nil
    
    var questions:[question_ans]? = nil
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        print(formDetails)
        
      
    }
    
    
    
    
    func setupViews(){
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        self.formTitleLbl.text = formDetails?.section_name
        if(self.formDetails?.isSubSectionPresent != "true"){
            self.questions = self.formDetails?.questions ?? []
            setupCollectionView()
        }
     print(questions)
        //self.formCollection.reloadData()
       

    }

    @IBAction func onDatePickerBtnClick(_ sender: Any) {
     
    }
   
    func setupCollectionView(){
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerNibs(["FormCollectionViewCell"])
       // self.formCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormCollectionViewCell", for: indexPath) as? FormCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        return cell
    }

}

extension FormViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(
       _ collectionView: UICollectionView,
       layout collectionViewLayout: UICollectionViewLayout,
       sizeForItemAt indexPath: IndexPath
     ) -> CGSize {
       // 2
         let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
             let availableWidth = view.frame.width - paddingSpace
             let widthPerItem = availableWidth / itemsPerRow
             
             return CGSize(width: widthPerItem, height: widthPerItem)
     }
    
}

extension FormViewController:UICollectionViewDelegate{
    
}


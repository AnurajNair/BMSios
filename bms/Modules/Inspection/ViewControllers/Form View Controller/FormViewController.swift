//
//  BridgeDetailFormViewController.swift
//  bms
//
//  Created by Naveed on 27/10/22.
//

import UIKit

class FormViewController: UIViewController, UICollectionViewDataSource {
    let itemsPerRow: CGFloat = 1
    
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    let arr = [1,2,3]
   
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var formTitleLbl: UILabel!
    var formDetails: FormSection?  = nil
    var questions:[Question] {
        guard let questions = self.formDetails?.subSections.first?.questions else {
            return []
        }
        return questions.map {$0} as [Question]
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
    }
    func setupViews(){
        self.view.translatesAutoresizingMaskIntoConstraints = true
        UILabel.style([(view: formTitleLbl, style: TextStyles.ScreenSubTitle)])
        self.formTitleLbl.text = self.formDetails?.subSections.first?.subSectionName
    }

    @IBAction func onDatePickerBtnClick(_ sender: Any) {
     
    }
   
    func setupCollectionView(){
        self.collection.registerNibs(["FormCollectionViewCell"])
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormCollectionViewCell", for: indexPath) as? FormCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let question = questions[indexPath.row]
        let questionText = question.question ?? ""
        let response = question.response ?? ""
        let options = question.optionsArray
        let optionsAsString = options.compactMap {$0.value}
        let textFieldStyler = TTTextFieldStyler.userDetailsStyle
        let formStyler = TTFormElementViewStyler.userDetailsStyle

        if(question.questionTypeEnum == .text) {
            _ = cell.collectionFormElement.setupTextField(id: indexPath,
                                                          fieldTitle: questionText,
                                                          fieldValue: response,
                                                          textFieldStyling: textFieldStyler,
                                                          formStyling: formStyler)
        } else if(question.questionTypeEnum == .radioOptions){
            var selectedOptions: [Int] = []
            let selectedOptionIndex = options.firstIndex {
                $0.key == response
            }
            if let selectedOptionIndex  = selectedOptionIndex {
                selectedOptions.append(selectedOptionIndex)
            }
            cell.collectionFormElement.setupOptionsField(id: indexPath,
                                                         fieldTitle: questionText,
                                                         showFieldTitleByDefault: true,
                                                         isEditable: true,
                                                         isRequired: question.isMandatory,
                                                         optionValues: optionsAsString,
                                                         selectedItems: selectedOptions,
                                                         scrollDirection: .vertical,
                                                         numberOfItemsPerRow: 1.0,
                                                         asymmetricPadding: 2.0,
                                                         isEqualWidth: true,
                                                         isEqualHeight: true,
                                                         allowsDeselect: true,
                                                         showSelectAll: false,
                                                         showClear: true)
        }
        cell.collectionFormElement.delegate = self
        return cell
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
         let availableWidth = collectionView.bounds.width - paddingSpace
             let widthPerItem = availableWidth / itemsPerRow
             
         return CGSize(width: widthPerItem, height: 100)
     }
    
}

extension FormViewController:UICollectionViewDelegate{
    
}

extension FormViewController: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        guard let index = index as? IndexPath else {
            return
        }
        let question = questions[index.row]
        switch question.questionTypeEnum {
        case .text:
            question.response = item as? String
        case .radioOptions:
            guard let selectionOptionIndex = (item as? [Int])?.first else { return }
            question.response = question.optionsArray[selectionOptionIndex].key
        }
    }
    
    func setError(index: Any, error: String) {
        // Handle error
    }
}

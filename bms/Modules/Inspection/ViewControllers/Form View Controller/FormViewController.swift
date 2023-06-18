//
//  BridgeDetailFormViewController.swift
//  bms
//
//  Created by Naveed on 27/10/22.
//

import UIKit
import RealmSwift

protocol formViewControllerDelegate: AnyObject {
    func uploadFiles(_ files: [Any], for section: Int)
}

class FormViewController: UIViewController, UICollectionViewDataSource {
    let itemsPerRow: CGFloat = 1
    let itemsPerRowForGeneralSec: CGFloat = 2

    private let sectionInsets = UIEdgeInsets(
      top: 10.0,
      left: 10.0,
      bottom: 10.0,
      right: 10.0)
   
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var formTitleLbl: UILabel!
    weak var delegate: formViewControllerDelegate?

    var formDetails: FormSection?  = nil
    var questions:[Question] {
        guard let questions = self.formDetails?.subSections.first?.questions else {
            return []
        }
        return questions.map {$0} as [Question]
    }
  
    private var isGeneralDetailsSection: Bool {
        formDetails?.sectionName == "General Details"
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
        return (questions.count > 0 && !isGeneralDetailsSection) ? questions.count+1 : questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormCollectionViewCell", for: indexPath) as? FormCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        if indexPath.row == questions.count  {
            let files = (formDetails?.files ?? List<String>()).map { $0 } as [String]
            _ = cell.collectionFormElement.setupFileField(id: indexPath,
                                                          fieldTitle: "Image Upload",
                                                          maxCount: 10,
                                                          previewImageContentMode: .scaleToFill,
                                                          isRequired: false,
                                                          files: files,
                                                          scrollDirection: .vertical,
                                                          numberOfItemsPerRow: 4,
                                                          isPreviewEnabled: true,
                                                          isCameraEnabled: true)
            cell.collectionFormElement.delegate = self
            return cell
        }

        let question = questions[indexPath.row]
        let questionText = question.question ?? ""
        let response = question.response ?? ""
        let options = question.optionsArray
        let optionsAsString = options.compactMap {$0.value}
        let textFieldStyler = TTTextFieldStyler.userDetailsStyle
        let formStyler = TTFormElementViewStyler.userDetailsStyle
        let isRequired = question.isMandatory
        
        if(question.questionTypeEnum == .text) {
            _ = cell.collectionFormElement.setupTextField(id: indexPath,
                                                          fieldTitle: questionText,
                                                          fieldValue: response,
                                                          isRequired: isRequired,
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
                                                         isRequired: isRequired,
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
         //Image field
         guard indexPath.row != questions.count else {
            return  CGSize(width: collectionView.bounds.width, height: 600)
         }
         let itemsPerRow = isGeneralDetailsSection ? itemsPerRowForGeneralSec : itemsPerRow
         let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
         let fullWidth = collectionView.bounds.width
         let availableWidth = fullWidth - paddingSpace
         let isLastOddIndexQuestion = isGeneralDetailsSection && (indexPath.row == questions.count-1) && (indexPath.section%2 == 0) // for last question of general details section that is on odd number in position give full width
         let widthPerItem = isLastOddIndexQuestion ? fullWidth : availableWidth / itemsPerRow
             
         return CGSize(width: widthPerItem, height: 100)
     }
    
}

extension FormViewController:UICollectionViewDelegate{
    
}

extension FormViewController: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        guard let index = index as? IndexPath, index.row < questions.count else {
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

    func uploadFilesDidTap(index: Any, files: [Any]) {
        guard let sectionIndex = formDetails?.sectionIndex else { return }
        delegate?.uploadFiles(files, for: sectionIndex)
    }
}

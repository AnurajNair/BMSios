//
//  BridgeDetailFormViewController.swift
//  bms
//
//  Created by Naveed on 27/10/22.
//

import UIKit

class FormViewController: UIViewController {
    @IBOutlet weak var inspectionDatePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerBtn: UIButton!
    
    
    @IBOutlet weak var bridgeNameTextField: UITextField!
    
    
    @IBOutlet weak var gradeNameTextField: UITextField!
    
    
    @IBOutlet weak var highwayNameTextField: UITextField!
    
    @IBOutlet weak var highwayNoTextField: UITextField!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var bridgeLocationTextField: UITextField!
    
    @IBOutlet weak var bridgeTypeTextField: UITextField!
    
    @IBOutlet weak var formTitleLbl: UILabel!
    var formDetails: sections?  = nil
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupViews()
        
      
print(formDetails)
    }
    
    
    func setupViews(){
        self.view.translatesAutoresizingMaskIntoConstraints = true
//        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        self.mainStackView.addConstraint(mainStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width))
//
//       // self.mainStackView.bounds.size.width = UIScreen.main.bounds.width
//        self.mainStackView.frame.size.width = UIScreen.main.bounds.width
        
        self.formTitleLbl.text = formDetails?.section_name
        self.bridgeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.gradeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.highwayNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.highwayNoTextField.translatesAutoresizingMaskIntoConstraints = false
        self.bridgeLocationTextField.translatesAutoresizingMaskIntoConstraints = false
        self.bridgeTypeTextField.translatesAutoresizingMaskIntoConstraints = false
//        self.inspectionDatePicker.isHidden = true
        self.bridgeNameTextField.addConstraint(bridgeNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
        self.gradeNameTextField.addConstraint(gradeNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
      
        self.highwayNameTextField.addConstraint(self.highwayNameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
        self.highwayNoTextField.addConstraint(self.highwayNoTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
        self.bridgeLocationTextField.addConstraint(self.bridgeLocationTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
        self.bridgeTypeTextField.addConstraint(self.bridgeTypeTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5))
        
        self.bridgeNameTextField.addConstraint(self.bridgeNameTextField.heightAnchor.constraint(equalToConstant: 48))
        self.gradeNameTextField.addConstraint(self.gradeNameTextField.heightAnchor.constraint(equalToConstant: 48))
        self.highwayNameTextField.addConstraint(self.highwayNameTextField.heightAnchor.constraint(equalToConstant: 48))
        self.highwayNoTextField.addConstraint(self.highwayNoTextField.heightAnchor.constraint(equalToConstant: 48))

        self.bridgeLocationTextField.addConstraint(self.bridgeLocationTextField.heightAnchor.constraint(equalToConstant: 48))
        self.bridgeTypeTextField.addConstraint(self.bridgeTypeTextField.heightAnchor.constraint(equalToConstant: 48))


    }

    @IBAction func onDatePickerBtnClick(_ sender: Any) {
        if inspectionDatePicker.isHidden {
                   // save the date for your need
//                   showDate.text = "\(myDatePicker.date)"
                   inspectionDatePicker.isHidden = false
                  /// myButtonx.setTitle("Done",forState: UIControlState.Normal)
               } else {
                   inspectionDatePicker.isHidden = true
                  // myButtonx.setTitle("Pick Date",forState: UIControlState.Normal)
               }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

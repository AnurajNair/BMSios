//
//  ReusablePopupViewController.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class ReusablePopupViewController: UIViewController {
    
    var selectionView:ReusablePopupSelectionView!
    
    weak var delegate: ReusablePopupFieldSelectionViewDelegate?
    
    var pageTitle = ""
    var selectedItems: [Int] = []
    var eventName: AnalyticsHelper.ScreenType? = nil
    var analyticsData: [String: Any] = [:]
    var data: [String] = []
    var minCount: Int = 0
    var maxCount: Int = 0
    var isEditable: Bool = true
    var allowsDeselect: Bool = true
    var isFormField : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageTitle
        setupSelectionView()
        setupNavigation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if eventName != nil {
            AnalyticsHelper.logEventWithName(eventName: eventName!, parameters: analyticsData)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Cause:- Using Popup contrller seperatley every time its calling if user dosent change anything so its calling everytime
        if self.isFormField {
            self.delegate?.saveButtonTapped?(selectedItems)
        }
    }
    
    //MARK:- Setup Functions
    
    func setupNavigation() {
        
        if let navController = self.navigationController {
            navController.navigationBar.barTintColor =  FormElementStyler.Popup.popupViewBarTintColor.getColorWithTranslucency(true)
            navController.navigationBar.tintColor = FormElementStyler.Popup.popupViewTintColor
            
            let attributes = [ NSAttributedString.Key.foregroundColor : FormElementStyler.Popup.popupViewBarTextColor, NSAttributedString.Key.font :  FormElementStyler.Popup.popupViewBarFont]
            navController.navigationBar.titleTextAttributes = attributes
        }
        
    }
    
    func setupSelectionView() {
        
        selectionView = ReusablePopupSelectionView()
        self.view.addSubview(selectionView)
        
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        selectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            selectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        self.selectionView.delegate = self
        
        self.selectionView.updateData(value: self.data, selectedItems: selectedItems, minCount: minCount, maxCount: maxCount, isEditable: isEditable, allowsDeselect: allowsDeselect)
        
    }
    
}

extension ReusablePopupViewController: ReusablePopupFieldSelectionViewDelegate {
    func saveButtonTapped(_ selectedItems: [Any]) {
        self.selectedItems = selectedItems as! [Int]
        Navigate.routeUserBack(self) {
            if !self.isFormField {
                self.delegate?.saveButtonTapped?(selectedItems)
            }
        }
    }
}


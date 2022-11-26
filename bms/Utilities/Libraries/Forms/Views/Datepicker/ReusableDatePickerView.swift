//
//  ReusableDatePickerView.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import UIKit

protocol ReusableDatePickerViewDelegate: class {
    func datePickerValueChanged(selectedDate: Date)
}

class ReusableDatePickerView: UIDatePicker {
    
    weak var delegate: ReusableDatePickerViewDelegate?
    
    enum DatePickerType {
        case dateOfBirth
        case dateFromToday
        case dateUntilToday
        case custom
        
        func getDatePickerViewMode(_ pickerMode:UIDatePicker.Mode = .date, minimumDate: Date? = nil, maximumDate: Date? = nil) -> (UIDatePicker.Mode, Date?, Date?) {
            switch self {
            case .dateOfBirth:
                return (.date, minimumDate ?? Date().newDateInYears(-150), maximumDate ?? Date().newDateInYears(0))
            case .dateFromToday:
                return (pickerMode, Date().newDateInYears(0), maximumDate)
            case .dateUntilToday:
                return (pickerMode, minimumDate, Date().newDateInYears(0))
            case .custom:
                return (pickerMode, minimumDate, maximumDate)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureDatePickerView(datePickerType: DatePickerType = .custom,
                                 datePickerMode: UIDatePicker.Mode = UIDatePicker.Mode.date,
                                 minimumDate: Date? = nil,
                                 maximumDate: Date? = nil,
                                 currentDate: Date = Date()) {
        
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.backgroundColor = UIColor.white
        self.addTarget(self, action: #selector(self.changeValue(_:)), for: UIControl.Event.valueChanged)
        
        let (pickerMode, minDate, maxDate) = datePickerType.getDatePickerViewMode(datePickerMode, minimumDate: minimumDate, maximumDate: maximumDate)
        
        self.datePickerMode = pickerMode
        
        if minDate != nil {
            self.minimumDate = minDate
        }
        
        if maxDate != nil {
            self.maximumDate = maxDate
        }
        
        self.setDate(currentDate, animated: true)
        
    }
    
    @objc func changeValue(_ sender : AnyObject?) {
        if let datePicker : UIDatePicker = sender as? UIDatePicker {
            self.delegate?.datePickerValueChanged(selectedDate: datePicker.date)
        }
    }
    
}


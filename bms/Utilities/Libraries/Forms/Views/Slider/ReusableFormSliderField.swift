//
//  ReusableFormSliderField.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit
import MaterialComponents.MaterialSlider

@objc protocol ReusableFormSliderFieldDelegate:class {
    @objc optional func viewDidChangeSliderHeight(height: CGFloat)
    @objc optional func viewDidUpdateValue(value: Any)
}

class ReusableFormSliderField: UIView {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var levelsStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    var view: UIView!
    var levels: [String] = []
    var selectedLevel: Int = 0
    var shouldShowStatus = false
    var inDisplayMode = false
    var shouldShowLevels = false
    var isEditable = false
    var fieldDelegate: ReusableFormSliderFieldDelegate!
    var leftImage: Any? = nil
    var leftImageRenderingMode: UIView.ContentMode = .scaleAspectFit
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = initFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = initFromNib()
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        styleView()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func styleView() {
        
        titleLabel.font = FormElementStyler.Slider.titleFont
        titleLabel.textColor = FormElementStyler.Slider.titleColor
        
        statusLabel.font = FormElementStyler.Slider.statusFont
        statusLabel.textColor = FormElementStyler.Slider.statusColor
        
    }
    
    //MARK:- Update Functions
    
    func setupSliderFormField(title: String = "",
                              levels: [String] = [],
                              selectedLevel: Int = 0,
                              shouldShowStatus: Bool = true,
                              shouldShowLevels: Bool = true,
                              leftImage: Any? = nil,
                              leftImageRenderingMode: UIView.ContentMode = .scaleAspectFit,
                              isEditable: Bool = true,
                              inDisplayMode: Bool = false) {
        
        self.levels = levels
        self.selectedLevel = selectedLevel
        self.shouldShowStatus = shouldShowStatus
        self.shouldShowLevels = shouldShowLevels
        self.isEditable = isEditable
        self.inDisplayMode = inDisplayMode
        self.leftImage = leftImage
        self.leftImageRenderingMode = leftImageRenderingMode
        
        setTitle(to: title)
        setLeftImage()
        setStatusLabel(to: levels[selectedLevel])
        
        setupSliderView()
        setupLevelsStackView()
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.fieldDelegate.viewDidChangeSliderHeight?(height: self.frame.size.height)
        
    }
    
    
    //MARK:- Helper Functions
    
    private func setupSliderView() {
        
        self.sliderView.isHidden = inDisplayMode
        
        if !inDisplayMode {
            let slider = MDCSlider(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 20))
            
            slider.addTarget(self,
                             action: #selector(didChangeSliderValue(senderSlider:)),
                             for: .valueChanged)
            
            slider.color = FormElementStyler.Slider.sliderColor
            slider.trackBackgroundColor = FormElementStyler.Slider.sliderTrackBackgroundColor
            
            slider.minimumValue = 0
            
            if self.levels.count > 1 {
                slider.numberOfDiscreteValues = UInt(self.levels.count)
                slider.maximumValue = CGFloat(self.levels.count - 1)
            } else {
                slider.maximumValue = 1
            }
            
            slider.shouldDisplayDiscreteValueLabel = false
            slider.value = CGFloat(selectedLevel)
            self.sliderView.addSubview(slider)
        }
        
        self.sliderView.isUserInteractionEnabled = self.isEditable
        
    }
    
    private func setupLevelsStackView() {
        
        if !inDisplayMode && shouldShowLevels {
            self.levelsStackView.distribution = .fillEqually
            self.levelsStackView.axis = .horizontal
            
            for subview in self.levelsStackView.subviews {
                subview.removeFromSuperview()
            }
            
            for (index, level) in self.levels.enumerated() {
                let label = UILabel()
                label.font = FormElementStyler.Slider.levelsLabelFont
                label.textColor = FormElementStyler.Slider.levelsLabelColor
                label.text = level
                if index == 0 {
                    label.textAlignment = .left
                } else if index == self.levels.count - 1 {
                    label.textAlignment = .right
                } else {
                    label.textAlignment = .center
                }
                self.levelsStackView.addArrangedSubview(label)
            }
        }
        
        self.levelsStackView.isHidden = (inDisplayMode || !shouldShowLevels)
        
    }
    
    private func setTitle(to text: String) {
        self.titleLabel.text = text
        self.titleLabel.isHidden = text.isEmpty
    }
    
    private func setLeftImage() {
        
        leftImageView.isHidden = false
        leftImageView.contentMode = leftImageRenderingMode
        
        if let imageString = leftImage as? String, !imageString.isEmpty {

            leftImageView.cacheImage(url: imageString)
        }
            
        else if let imageValue = leftImage as? UIImage {
            leftImageView.image = imageValue
        }
            
        else {
            leftImageView.isHidden = true
        }
        
    }
    
    private func setStatusLabel(to text: String = "") {
        self.statusLabel.text = text
        self.statusLabel.isHidden = text.isEmpty
        self.statusLabel.isHidden = !shouldShowStatus
    }
    
    //MARK:- Action Functions
    
    @objc func didChangeSliderValue(senderSlider:MDCSlider) {
        var selectedLevel = ""
        if self.levels.count > 0 {
            selectedLevel = self.levels[Int(senderSlider.value)]
        } else {
            selectedLevel = "\(senderSlider.value)"
        }
        self.statusLabel.text = selectedLevel
        
        self.fieldDelegate.viewDidUpdateValue?(value: Int(senderSlider.value))
    }
}


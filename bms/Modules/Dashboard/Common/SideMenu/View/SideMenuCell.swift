//
//  SideMenuCell.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit



class SideMenuCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var menCellView: UIView!
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cellStack: UIStackView!
    @IBOutlet weak var subMenuTable: UITableView!
    
    @IBOutlet weak var menStackView: UIStackView!
    
    var subMenu:[SideMenuModel]?
    
     var delegate:SideMenuCellDelegate?
    
    var title:String?
    
    var isOpen:Bool?
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
        setupView()
       setupTableView()
    }
    
    func setupView(){
       
        UIView.style([(view: menCellView, style:(backgroundColor:nil, cornerRadius: 8, borderStyle: nil,shadowStyle : nil))])
        
        menuLabel.textColor = UIColor.black
      
      //  menCellView.frame.size.height = UIScreen.main.bounds.size.height/6
       
    }
    
  
    func configureCell(image:String,title:String,menu:[SideMenuModel]?,isSelected:Bool?){
        _ = {(action: UIAction) in print("hello")}
        self.menuIcon.image = UIImage(named: image)
        self.menuLabel.text = title
        self.subMenu = menu
//        self.cellStack.addConstraint(self.cellStack.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>))
//        self.title = title
//        print(title , menu)
        setupTableView()
        
        if(isSelected!){
            if(title == "Inspection"){
                self.menuView.backgroundColor = UIColor.BMS.theme
                self.menuView.setAsRounded(cornerRadius: 5.0)
                self.menuLabel.textColor = UIColor.BMS.white
                self.arrowIcon.image = UIImage(named: "chevron-down")
                self.menuIcon.image = UIImage(named: "inspection")
            }else{
                self.menuView.backgroundColor = UIColor.BMS.theme
                self.menuView.setAsRounded(cornerRadius: 5.0)
                self.menuLabel.textColor = UIColor.BMS.white
                
//                self.arrowIcon.image = UIImage(named: "chevron-down")
            }
            
        }else{
            if(title == "Inspection"){
                self.arrowIcon.image = UIImage(named: "forwardArrowIcon")
                self.menuIcon.image = UIImage(named: "inspectionIcon")
            }else if(title == "Dashboard"){
                self.arrowIcon.image = UIImage(named: "forwardArrowIcon")
                self.menuIcon.image = UIImage(named: "dashboardColorIcon")
            }else{
                self.arrowIcon.image = UIImage(named: "forwardArrowIcon")
                self.menuIcon.image = UIImage(named: "dashboardColorIcon")
            }
        }
        
      
//        if(title == "Inspection"){
//            subMenuTable.isHidden = false
//        }else{
//            subMenuTable.isHidden = true
//        }
//        self.menuButton.menu = UIMenu(children: [UIAction(title:"First Item", state: .on ,handler: optionClosure),UIAction(title:"Second Item" ,handler: optionClosure)])
    }
    
   

    
    
    func setupTableView(){
        // TableView
       
        self.subMenuTable.delegate = self
        self.subMenuTable.dataSource = self
        self.subMenuTable.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.subMenuTable.separatorStyle = .none
//        self.subMenuTable.isHidden = true
//        self.subMenuTable.registerNibs(["SideMenuCell"])
      //  addSubview(self.subMenuTable)
        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.subMenuTable.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }

//        // Footer
//        self.footerLabel.textColor = UIColor.white
//        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        self.footerLabel.text = "Developed by John Codeos"

         //Register TableView Cell
        self.subMenuTable.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
//
        
//
//        // Update TableView with the data
  self.subMenuTable.reloadData()
    }
    
  
    
    
}

extension SideMenuCell{
    func selectedTitle(title:String){
        self.title = title
        if title == "Inspection"{
            self.subMenuTable.isHidden = false
//            changeBackground()
        }else{
            self.subMenuTable.isHidden = true
        }
    }
    
    func changeBackground (){
       
        self.menCellView.backgroundColor = UIColor.BMS.theme
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
      
    }
    
}

extension SideMenuCell: UITableViewDelegate{
    
}

extension SideMenuCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.subMenu != nil){
        return self.subMenu!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        let sectionData = self.subMenu![indexPath.row]
        cell.delegate = self.delegate;
        print(sectionData)
     
        
       
        
        cell.configureCell(image:sectionData.icon, title: sectionData.title,menu: [],isSelected: false)

        // Highlighted color
//        let myCustomSelectionColorView = UIView()
//        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.3321178555, green: 0.4342988431, blue: 0.5135810375, alpha: 1)
//        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath)
        let sectionData = self.subMenu![indexPath.row]
        delegate?.onSideSubMenuClick(indexPath.row)
        Navigate.routeUserToScreen(screenType: sectionData.route, transitionType: sectionData.transition)
        
    }
}

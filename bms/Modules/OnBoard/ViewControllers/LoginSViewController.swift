//
//  LoginViewController.swift
//  bms
//
//  Created by Naveed on 29/11/22.
//

import UIKit

class LoginSViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var loginFieslTable: UITableView!
    
    let cells = ["userName","password","buttons"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        // Do any additional setup after loading the view.
    }
    
    
    func setupViews(){
        loginFieslTable.addConstraint(loginFieslTable.heightAnchor.constraint(equalToConstant: self.card.frame.size.height/2))
        loginFieslTable.addConstraint(loginFieslTable.widthAnchor.constraint(equalToConstant: self.card.frame.size.width/1.2))
        NSLayoutConstraint(item: self.loginFieslTable as Any, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: card, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.loginFieslTable as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: card, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        setupTableView()
    }

    func setupTableView(){
        self.loginFieslTable.delegate = self
        self.loginFieslTable.dataSource = self
        self.loginFieslTable.registerNibs([FormElementTableViewCell.identifier,LoginTableButtonsCell.identifier])
        self.loginFieslTable.registerHeaderNibs(["LoginHeaderView"])
        self.loginFieslTable.reloadData()
    }
    
    func setInputCells(_ indexPath:IndexPath)->UITableViewCell{
        guard let cell = loginFieslTable.dequeueReusableCell(withIdentifier: FormElementTableViewCell.identifier, for: indexPath) as? FormElementTableViewCell else{
            return UITableViewCell()
        }
        
     _ =   cell.formElementView.setupTextField(id: indexPath, fieldTitle: "User Name",  placeholderTitle: "User name",  isEditable: true,  fieldSubtype: .email, textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
        return cell
        
    }
    func setButtonCell(_ indexPath:IndexPath)->UITableViewCell{
        guard let cell = loginFieslTable.dequeueReusableCell(withIdentifier: LoginTableButtonsCell.identifier, for: indexPath) as? LoginTableButtonsCell else{
            return UITableViewCell()
        }
        
     
        
        return cell
        
    }

}

extension LoginSViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 3
    }
    
}

extension LoginSViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell = UITableViewCell()
        if(indexPath.row == 2){
            cell = self.setButtonCell(indexPath)
            
        }else{
            cell =  self.setInputCells(indexPath)
        }
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.loginFieslTable.dequeueReusableHeaderFooterView(withIdentifier: "LoginHeaderView")  as? LoginHeaderView

      
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

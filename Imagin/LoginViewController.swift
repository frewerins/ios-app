//
//  LoginViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 11.07.2021.
//

import UIKit

class LoginViewController: ViewController {

    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        AppUtility.lockOrientation(.portrait)
        
        CustomizeGrayButton(button: createAccountButton)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        CustomizeBlueButton(button: loginButton)
        CustomizeTextField(field: emailField)
        CustomizeTextField(field: passwordField)
        // Do any additional setup after loading the view.
    }
    

}

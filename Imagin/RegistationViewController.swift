//
//  RegistationViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 11.07.2021.
//

import UIKit

class RegistationViewController: ViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomizeTextField(field: emailField)
        CustomizeTextField(field: passwordField)
        CustomizeTextField(field: repeatPasswordField)
        CustomizeBlueButton(button: registrationButton)
        // Do any additional setup after loading the view.
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

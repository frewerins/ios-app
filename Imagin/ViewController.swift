//
//  ViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 05.03.2021.
//

import UIKit


let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let buttonHeight = 50 * screenHeight / 816
let buttonWidth = 221 * buttonHeight / 50


extension UIColor {
    static let customGrayColor: UIColor = UIColor(named: "customGray")!
    static let customBlueColor: UIColor = UIColor(named: "customBlue")!
    static let customBackgroundColor: UIColor = UIColor(named: "customBackground")!
    static let customBlueHoverColor: UIColor = UIColor(named: "customBlueHover")!
}


func CustomizeGrayButton(button: UIButton) {
    button.setTitleColor(UIColor.customGrayColor, for: .normal)
}

func CustomizeBlueButton(button: UIButton) {
    button.setTitleColor(UIColor.white, for: .normal)
    button.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
    //button.layer.cornerRadius = 10
    button.setBackgroundImage(UIImage(named: "addButtonBackground"), for: .normal)
    //button.backgroundColor = UIColor.customBlueColor
    //button.backgroundColor.
}

func CustomizeTextField(field: UITextField) {
    field.layer.cornerRadius = 8
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.customBlueColor.cgColor
    field.textColor = UIColor.customGrayColor
    field.addConstraint(field.heightAnchor.constraint(equalToConstant: buttonHeight))
    field.addConstraint(field.widthAnchor.constraint(equalToConstant: screenWidth * 302 / 375))
    field.clearButtonMode = .unlessEditing
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addImageToNavBar()
        print("ded kek")
        self.navigationItem.title = ""
        // Do any additional setup after loading the view.
    }
    
    func addImageToNavBar() {
        if let navController = navigationController {
            let imageLogo = UIImage(named: "IMAGIN")
            let withNavBar = navController.navigationBar.frame.width
            let heightNavBar = navController.navigationBar.frame.height
            
            let withForView = 0.165 * withNavBar
            let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: withForView, height: heightNavBar))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: withForView, height: heightNavBar))
            imageView.image = imageLogo
            imageView.contentMode = .scaleAspectFit
            logoContainer.addSubview(imageView)
            navigationItem.titleView = logoContainer
            
        } else {
            print("нет навбара")
        }
    }


}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}


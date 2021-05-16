//
//  ViewController.swift
//  Imagin
//
//  Created by a.d.knyazeva on 05.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addImageToNavBar()
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

